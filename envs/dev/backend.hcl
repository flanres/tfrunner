# TODO: Remote State 用 Storage を bootstrap（別管理/手動 or 別スタック）で作成し、実値に置換してください。
resource_group_name  = "rg-tfstate-dev"
storage_account_name = "todotfstatedevsa" # TODO: 実在する名前（小文字英数字のみ、3-24文字）
container_name       = "tfstate"          # TODO
key                  = "apim-rg/dev.tfstate"
