<?php

namespace MichaelsBookClub;

use Dotenv;
use MichaelsBookClub\Utils\Router;
use MichaelsBookClub\Middleware\CORSMiddleware;

require_once __DIR__ . '/../vendor/autoload.php';
$dotenv = Dotenv\Dotenv::createUnsafeImmutable(__DIR__);
$dotenv->load();

class ApiEntry
{
    private $router;

    public function __construct()
    {
        session_start();

        $this->router = new Router;
    }

    public function handleRequest()
    {
        $method = $_SERVER['REQUEST_METHOD'];
        $path = $_SERVER['REQUEST_URI'];
        $requestBody = json_decode(file_get_contents('php://input'), true);

        $this->applyMiddleware($path);
        $this->router->handleRequest($method, $path, $requestBody);
    }

    private function applyMiddleware()
    {
        $corsMiddleware = new CORSMiddleware;
        $corsMiddleware->handle();
    }
}

$apiEntry = new ApiEntry;
$apiEntry->handleRequest();
