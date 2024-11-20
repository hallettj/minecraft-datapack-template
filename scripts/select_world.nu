let minecraft_save_locations = [
  ~/.local/share/PrismLauncher/instances/*/.minecraft/saves/*
  ~/.var/app/com.mojang.Minecraft/data/minecraft/saves/*
  ~/.minecraft/saves/*
]

def save_directories []: nothing -> list<string> {
  $minecraft_save_locations | each { |it| glob $it } | flatten
}

def prompt_for_world []: list<string> -> string {
  $in
    | str join "\n"
    | fzf --height=~100% --min-height=20 --prompt "Which world do you want to install the datapack to for testing? "
}

def record_selection []: string -> nothing {
  $in | save --force selected_world
}

def main [] {
  save_directories | prompt_for_world | record_selection
  echo "Your selected world was saved in the file selected_world. To change your selection delete selected_world before running the install command again."
}
