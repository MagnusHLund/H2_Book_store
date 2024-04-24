<?php

namespace MichaelsBookClub\Utils;

use MichaelsBookClub\Handlers\UserHandler;
use MichaelsBookClub\Handlers\ProductHandler;
use MichaelsBookClub\Handlers\OrderHandler;
use MichaelsBookClub\Handlers\CheckoutHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/";

        $userHandler = new UserHandler;

        $loginRoute = "login/";

        $productHandler = new ProductHandler;

        $productRoute = "Products/";

        $orderHandler = new OrderHandler;

        $orderRoute = "Orders/";

        $checkoutHandler = new CheckoutHandler;

        $checkoutRoute = "Checkout/";
        
        

        // Routes are made up in 3 parts. 1. Request type, 2. API url, 3. function to call
        $this->routes = [
            // Login
            ["POST", $baseUrl . $loginRoute . "login", [$userHandler, "login"]]
        ];

        $this->routes = [
            // Product
            ["POST", $baseUrl . $productRoute . "login", [$productHandler, "login"]]
        ];

        $this->routes = [
            // Order
            ["POST", $baseUrl . $orderRoute . "login", [$orderHandler, "login"]]
        ];

        $this->routes = [
            // Checkout
            ["POST", $baseUrl . $checkoutRoute . "login", [$checkoutHandler, "login"]]
        ];
    }


    public function handleRequest($method, $path, $requestBody)
    {
        foreach ($this->routes as $route) {
            list($routeMethod, $routePath, $handler, $params) = $route + [null, null, null, []];
            if ($method === $routeMethod && $path === $routePath) {
                call_user_func_array([$handler[0], $handler[1]], [[$requestBody], $params]);
                return;
            }
        }

        http_response_code(404);
        echo json_encode(["error" => "Route does not exist!"]);
        exit;
    }
}
