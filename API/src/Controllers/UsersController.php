<?php

namespace DavidsBookClub\Handlers;

use DavidsBookClub\Utils\Database;
use DavidsBookClub\Utils\MessageManager;
use DavidsBookClub\Utils\SecurityManager;

class UsersController
{
    private $securityManager;

    public function __construct()
    {
        $this->securityManager = new SecurityManager();
    }

    /**
     * This function gets user billing information.
     * To identify the user, a JWT is used to get the userId
     */
    public function getUserBillingInfo()
    {
        // Call SP with the UserId as a parameter. Return stored user billing information.

        $billingInfo = "";
        MessageManager::sendSuccess($billingInfo);
    }

    /**
     * This function creates a user in the database.
     * @param object $payload This parameter holds all the data required to create a user.
     *              `$payload->name`
     *              `$payload->email`
     *              `$payload->password`
     *              `$payload->verifyPassword`
     *              `$payload->houseNumber`
     *              `$payload->zipCode`
     *              `$payload->streetName`
     */
    public function createUser($payload)
    {
        if (isset(
            $payload->name,
            $payload->email,
            $payload->password,
            $payload->verifyPassword,
            $payload->houseNumber,
            $payload->zipCode,
            $payload->streetName
        )) {
            if ($payload->password != $payload->verifyPassword) {
                MessageManager::sendError("Passwords do not match", 401);
                exit;
            }

            if (!$this->securityManager->verifyNewPassword($payload->password)) {
                MessageManager::sendError("Password does not follow requirements", 401);
                exit;
            }
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function is used to login a user.
     * @param object $payload `$payload->email` and `$payload->password` is used to login the user.
     */
    public function loginUser($payload)
    {
        if (isset($payload->email, $payload->password)) {
            // Call SP to receive userId, password and salt, from the user.

            $response = "";
            if (empty($response)) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            if (!$this->securityManager->verifyHashedPassword($payload->password, $response->password, $response->salt)) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            $jwt = $this->securityManager->encodeJwt($response->userId);
        }
    }

    /**
     * This function removes the user within the API session storage.
     */
    public function logoutUser()
    {
    }
}
