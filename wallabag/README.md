# Wallabag

<https://github.com/wallabag/docker>

- Rename `example.env` to `.env` and edit the variables

## Troubleshooting

INSTALL : default admin user is `wallabag/wallabag` (add another user and deactivate this account)

<https://doc.wallabag.org/admin/console_commands/>

- make sure to use the `--env=prod` arg in the commands, otherwise you get a PHP error `[critical] Uncaught Error: Class "Symfony\Bundle\DebugBundle\DebugBundle" not found`.

### Migrations

1. `docker compose exec -it wallabag /bin/sh`
2. `./bin/console doctrine:migrations:migrate --env=prod --no-interaction`

### Can't add a website

If in the logs there's `[error] 54#54: *5 FastCGI sent in stderr: "PHP message: PHP Warning:  mkdir(): Permission denied in /var/www/wallabag/vendor/friendsofsymfony/jsrouting-bundle/Extractor/ExposedRoutesExtractor.php on line 179" while reading response header from upstream, client: 172.18.0.2, server: _, request: "GET /js/routing?callback=fos.Router.setData HTTP/1.1", upstream: "fastcgi://127.0.0.1:9000"`, this may be a permission issue.

Run : `docker compose exec -t wallabag chown -R nobody:nogroup /var/www/wallabag`
