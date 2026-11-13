# Tests du module `one`

Ce document explique comment exécuter les tests unitaires du module Puppet
OpenNebula, comment ils sont organisés et comment corriger les erreurs les plus
courantes.

## Périmètre

Les tests actuellement pris en charge sont les tests unitaires :

- `spec/classes` : compilation des classes et vérification des ressources ;
- `spec/type` : définition des types Puppet personnalisés ;
- `spec/provider` : chargement et instanciation des providers ;
- `spec/support` : exemples partagés entre plusieurs specs.

Les tests présents dans `spec/acceptance` utilisent Beaker et des machines
virtuelles CentOS 6/7. Ils ne sont pas exécutés par défaut et ne font pas partie
de la réparation actuelle. Ils sont exclus par `.rspec`.

## Pourquoi un conteneur Ruby 3.2 ?

Le module est verrouillé sur Puppet 8.x et ses dépendances ne sont pas
compatibles avec Ruby 4.0, qui est la version installée par défaut sur Fedora 44.
Il faut donc utiliser Ruby 3.2.

La méthode recommandée est un conteneur Docker ou Podman, afin de ne pas modifier
le Ruby du système.

## Construire l'image de test

```bash
podman build -t one-tests-ruby32 - <<'EOF'
FROM docker.io/library/ruby:3.2-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential pkg-config git libffi-dev libxml2-dev libxslt1-dev libyaml-dev \
    && rm -rf /var/lib/apt/lists/*
EOF
```

Sous Docker, remplacer `podman` par `docker` dans les commandes suivantes.

## Ouvrir un shell de test

Important : le dépôt doit être monté avec le **même chemin** à l'intérieur et à
l'extérieur du conteneur. Sinon, la symlink `spec/fixtures/modules/one` pointe
vers un chemin qui n'existe pas dans le conteneur et RSpec échoue avec
`Errno::EEXIST: File exists - spec/fixtures/modules/one`.

Depuis la racine du dépôt :

```bash
podman run --rm -it \
  -e HOME=/tmp \
  -e BUNDLE_PATH="$PWD/vendor/bundle" \
  -e PUPPET_GEM_VERSION='~> 8.0' \
  -v "$PWD:$PWD:z" \
  -w "$PWD" \
  one-tests-ruby32 bash
```

Puis, dans le conteneur :

```bash
bundle install
bundle exec rake spec_prep
```

`bundle install` installe les gems dans `vendor/bundle`, qui est ignoré par Git.
`rake spec_prep` installe les modules de fixtures déclarés dans `.fixtures.yml`
(`stdlib`, `inifile`, `yumrepo_core`, `cron_core`) et crée la symlink du module.

## Lancer les tests

Tous les tests unitaires :

```bash
bundle exec rspec spec
```

Les tests d'un sous-répertoire :

```bash
bundle exec rspec spec/classes
bundle exec rspec spec/type
bundle exec rspec spec/provider
```

Un fichier précis :

```bash
bundle exec rspec spec/classes/opennebula_spec.rb
```

Un exemple précis, avec le numéro de ligne :

```bash
bundle exec rspec spec/classes/opennebula_spec.rb:42
```

La tâche Rake standard :

```bash
bundle exec rake spec
```

Attention : `rake spec` prépare les fixtures puis les nettoie à la fin. Après son
exécution, il faut relancer `bundle exec rake spec_prep` avant de pouvoir utiliser
directement `bundle exec rspec spec`. Pour nettoyer manuellement les fixtures :

```bash
bundle exec rake spec_clean
```

### Lint

Le lint Puppet se lance avec :

```bash
bundle exec rake lint
```

Il existe encore des avertissements préexistants dans les manifests
(documentation des paramètres de classes internes, espaces en fin de ligne). Ils
ne bloquent pas les tests unitaires et ne font pas partie de cette réparation.

## Comprendre les tests

### `rspec-puppet`

Les specs de classes ne créent pas de vraies ressources sur la machine. Elles
compilent un catalogue Puppet en mémoire et vérifient son contenu :

```ruby
it { is_expected.to contain_package('opennebula') }
it { is_expected.to contain_service('opennebula').with_ensure('running') }
```

Le catalogue est produit avec les paramètres fournis par `let(:params)` et les
faits fournis par `let(:facts)`.

### Faits et systèmes supportés

`on_supported_os` provient de `rspec-puppet-facts` et de `facterdb`. Les
systèmes testés sont déduits de `metadata.json` (RedHat 7 et 8). Pour chaque
système, un contexte distinct est exécuté.

### Hiera

`spec/spec_helper.rb` configure Hiera avec
`spec/fixtures/hiera/hiera.yaml`. Ce fichier utilise le format Hiera 5 et charge
`spec/fixtures/hiera/test.yaml`.

Les clés de `test.yaml` doivent correspondre aux noms réellement utilisés par
les classes et par les lookups de `manifests/params.pp`. Par exemple :

```yaml
one::head::ssh_pub_key: 'ssh pub key'
one::head::ssh_priv_key: 'ssh-dsa priv key'
one::repo_enable: true
```

Attention aux types : `one::repo_enable` doit être un booléen et
`one::oned_xmlrpc_maxconn` un entier, pas des chaînes de caractères.

### Fixtures

Les modules externes nécessaires aux tests sont installés dans
`spec/fixtures/modules` par :

```bash
bundle exec rake spec_prep
```

Après une modification de `.fixtures.yml`, relancer cette commande.

Puppet 8 ne fournit plus certains types dans le cœur de Puppet. Le module utilise
`yumrepo` et `cron`, qui viennent désormais des modules Puppet Forge
`puppetlabs-yumrepo_core` et `puppetlabs-cron_core`. Ils sont déclarés à la fois
dans `.fixtures.yml` et dans `metadata.json`.

### Providers

Les providers sont chargés et instanciés, mais les opérations qui appellent
réellement les commandes OpenNebula (`onecluster`, `onehost`, etc.) restent en
`skip` ou `pending`. Elles nécessitent un environnement OpenNebula réel et
relèvent des tests d'acceptation.

Le feature `nokogiri` est optionnel pour les tests unitaires. Les providers
peuvent être chargés sans Nokogiri ; seules les opérations qui manipulent du XML
en ont besoin.

## Ajouter un test de classe

```ruby
require 'spec_helper'

describe 'one::exemple', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('one::exemple') }
      it { is_expected.to contain_file('/etc/one/exemple.conf').with_ensure('file') }
    end
  end
end
```

Si la classe dépend de variables définies par `class one`, deux solutions :

- passer explicitement les paramètres via `let(:params)` ;
- ou utiliser `let(:pre_condition)`, en évitant de redéclarer une classe déjà
  contenue par `class one`.

Exemple avec `pre_condition` pour une classe qui n'est pas incluse par défaut :

```ruby
let(:pre_condition) { "class { 'one': workernode => false, oned => true }" }
```

## Ajouter un test de type

Les exemples partagés sont dans `spec/support/shared_type_examples.rb`. Ils sont
chargés automatiquement par `spec_helper.rb`.

```ruby
parameter_tests = {
  name: {
    valid: ['test', 'foo'],
    default: 'test',
    invalid: ['0./fouzb&$', '&fr5'],
  },
}

it_should_behave_like 'a puppet type', parameter_tests, :oneexemple
```

## Erreurs fréquentes

### `Could not find shared examples "a puppet type"`

Le fichier `spec/support/shared_type_examples.rb` n'a pas été chargé. Vérifier
que `spec_helper.rb` contient :

```ruby
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }
```

### `Errno::EEXIST: File exists - spec/fixtures/modules/one`

Le dépôt n'est pas monté avec le même chemin dans le conteneur. Utiliser :

```bash
-v "$PWD:$PWD:z" -w "$PWD"
```

et non `-v "$PWD:/module" -w /module`.

### `Unknown resource type: 'yumrepo'` ou `'cron'`

Les modules `yumrepo_core` et `cron_core` ne sont pas installés. Lancer :

```bash
bundle exec rake spec_prep
```

### `parameter '...' expects an Integer value, got String`

Une valeur de `spec/fixtures/hiera/test.yaml` a le mauvais type. Corriger le
fichier YAML (booléen, entier, tableau ou hash selon le paramètre Puppet).

### `Could not find resource 'Service[opennebula]' in parameter 'require'`

La classe testée référence un service qui n'est pas déclaré dans le catalogue.
Ajouter un `pre_condition` qui déclare la classe `one` avec les bons paramètres,
ou déclarer explicitement le service nécessaire.

### Ruby 4.0 et gems incompatibles

Utiliser Ruby 3.2 via le conteneur décrit ci-dessus. Ne pas tenter
`bundle install` avec le Ruby 4.0 du système.

## Tests d'acceptation

Ils ne sont pas exécutés par `bundle exec rspec spec` et sont exclus par
`.rspec` :

```text
--exclude-pattern "spec/acceptance/**/*_spec.rb,..."
```

Pour les réactiver plus tard, il faudra :

- ajouter `beaker-rspec` aux dépendances de test ;
- remplacer les nodesets CentOS 6/7 obsolètes ;
- disposer d'un environnement OpenNebula réel ou de conteneurs dédiés.
