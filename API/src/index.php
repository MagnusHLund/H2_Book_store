<?php

namespace DavidsBookClub;

use Dotenv\Dotenv;
use DavidsBookClub\Middleware\AuthenticationMiddleware;
use DavidsBookClub\Middleware\CorsMiddleware;
use DavidsBookClub\Utils\Router;

require_once __DIR__ . '/../vendor/autoload.php';
$dotenv = Dotenv::createUnsafeImmutable(__DIR__);
$dotenv->load();

class ApiEntry
{
    public function __construct()
    {
        session_start();
    }

    public function handleRequest()
    {
        $method = $_SERVER['REQUEST_METHOD'];
        $path = $_SERVER['REQUEST_URI'];
        $requestBody = json_decode(file_get_contents('php://input'), true);

        $this->handleMiddleware($path);
        (new Router)->handleRequest($method, $path, $requestBody);
    }

    private function handleMiddleware($path)
    {
        CorsMiddleware::handleCors();
        AuthenticationMiddleware::handleAuthentication($path);
    }
}

(new ApiEntry)->handleRequest();
