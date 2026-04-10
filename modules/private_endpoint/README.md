# modules/private_endpoint

Private Endpoint を作成します（例: Storage Account の blob など）。

注意:
- Private DNS Zone の格納先が APIM_RG か共有DNS用RGかで運用が変わります（要件に合わせて `private_dns_zone_ids` を指定）。
