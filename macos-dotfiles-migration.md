# Migration des dotfiles sur macOS

Cette procédure déplace les anciens liens Stow vers les packages de `packages/`.
Elle conserve les configurations déjà actives. Elle ne lance pas le bootstrap et
n’installe ni outils ni plugins.

Remplace `~/dotfiles` ci-dessous si le dépôt est ailleurs. GNU Stow doit déjà être
installé; `dotfiles.sh` ne l’installe pas.

## 1. Avant la mise à jour du dépôt

Garde un terminal ouvert jusqu’à la fin. Vérifie l’état Git et note la révision
actuelle :

```bash
REPO="$HOME/dotfiles"
git -C "$REPO" status --short
git -C "$REPO" rev-parse HEAD
```

Si `git status --short` affiche des changements, arrête-toi. Sauvegarde ou traite
ces changements avant de mettre le dépôt à jour. Ne fais pas de `pull` avec un
répertoire de travail que tu n’as pas préservé.

Crée une sauvegarde hors du dépôt. Elle conserve l’ancienne révision et les
fichiers sources, y compris ceux qui ne sont pas suivis par Git :

```bash
STAMP="$(date +%Y%m%d-%H%M%S)"
PRE_BACKUP="$HOME/dotfiles-before-packages-$STAMP"
mkdir -p "$PRE_BACKUP"
git -C "$REPO" rev-parse HEAD > "$PRE_BACKUP/old-revision"
cp -a "$REPO" "$PRE_BACKUP/repository"
```

Sauvegarde aussi les chemins de configuration actifs dans `$HOME` et leurs
éventuelles données locales. Inclue au minimum les chemins que tu utilises parmi
`.zshrc`, `.zprofile`, `.zsh`, `.tmux`, `.tmux.conf`, `.wezterm.lua` et les
répertoires d’applications sous `.config/`, notamment `aerospace`, `karabiner`,
`nvim`, `ghostty` et `sesh`. Pour les liens symboliques, note leur destination avec
`readlink`; la copie du dépôt préserve les sources internes, mais sauvegarde aussi
séparément toute destination située hors du dépôt. Ne suis pas un lien étranger
sans vérifier où il mène.

## 2. Mettre à jour le dépôt

Récupère le commit contenant la réorganisation avec ta méthode habituelle. Les
anciens liens peuvent être brièvement pendants entre la mise à jour et la migration;
garde le terminal ouvert et passe à l’étape suivante sans délai inutile.

## 3. Simuler la migration

Depuis le dépôt mis à jour :

```bash
cd "$REPO"
./dotfiles.sh list
./dotfiles.sh migrate --dry-run
```

La version corrigée affiche `Scanning N known Stow target paths`; elle ne parcourt
pas tout `$HOME`. Si une ancienne version reste silencieuse en parcourant le dossier
personnel, `Ctrl+C` est sans danger pour les fichiers de configuration : la simulation
ne modifie que des fichiers temporaires. Mets à jour `dotfiles.sh` avant de réessayer.

Vérifie la sélection déduite des anciens liens. Elle doit correspondre aux
configurations qui étaient actives sur ce Mac. Un package partiellement actif
reste partiel : les autres fichiers du package ne seront pas ajoutés. Les
packages `macos-aerospace` et `macos-karabiner` ne seront sélectionnés que si
leurs anciens liens étaient actifs. Les packages `omarchy-*` sont incompatibles
avec macOS et doivent rester intacts.

**Arrête-toi sans lancer la migration réelle** si la sélection est inattendue,
si des chemins manquent sans explication ou si Stow signale un conflit. Ne
supprime pas le fichier concerné et n’utilise jamais `--adopt`.

## 4. Migrer et vérifier

Si la simulation est correcte :

```bash
./dotfiles.sh migrate
./dotfiles.sh check
```

La migration remplace les anciens liens reconnus par des liens vers les nouveaux
packages, sans activer les configurations qui ne l’étaient pas. Elle affiche le
chemin d’une sauvegarde et de son journal sous
`~/.local/state/dotfiles/migrations/`; conserve ce chemin.

Vérifie le shell et les applications que tu utilisais déjà :

```bash
zsh -n "$HOME/.zshrc"
```

Ouvre un nouveau shell et vérifie les packages qui étaient actifs, notamment
Aerospace ou Karabiner le cas échéant. `~/.config/sesh/sesh.toml` reste local.
N’exécute pas `./install.sh` et ne lance pas `stow .`.

Si `./dotfiles.sh check` signale un conflit, laisse le fichier intact et examine
le diagnostic avant toute autre action.

## 5. Retour arrière

Préserve d’abord tout changement fait depuis la migration. Tant que le nouveau
checkout est encore présent, utilise le chemin de sauvegarde affiché par
`migrate` :

```bash
./dotfiles.sh rollback "$HOME/.local/state/dotfiles/migrations/<horodatage>"
```

Cette commande enlève les nouveaux liens Stow et restaure les anciens liens. Ceux-ci
peuvent être pendants jusqu’à la restauration de l’ancienne révision. Restaure-la
ensuite avec la révision enregistrée avant la mise à jour :

```bash
OLD_REV="$(cat "$PRE_BACKUP/old-revision")"
git -C "$REPO" switch --detach "$OLD_REV"
```

Ne force pas le retour arrière si `rollback` s’arrête sur un chemin non vide :
préserve ce contenu et résous le conflit avant de continuer. Le retour arrière des
liens seuls ne peut pas recréer les anciennes sources; il faut aussi restaurer
l’ancienne révision ou la copie du dépôt faite avant la mise à jour.
