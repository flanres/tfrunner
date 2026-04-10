# modules/firewall

Azure Firewall（管理NIC有効）と Firewall Policy（FQDNホワイトリスト方式の最小例）を作成します。

- `allowed_target_fqdns` が空の場合は、ルールコレクショングループを作成しません（apply を通すため）。
- 実運用では、FQDN/ポート、TLS inspection、ログ送信、DNAT などを要件に応じて追加してください。
