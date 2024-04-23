<?php

class User {
 //properties and methods for new user and get user
    private $name;
    private $password;
    private $email;

    public function newUser($name,$password,$email){
        $this->name = $name;
        $this->password = $password;
        $this->email = $email;
    }

    public function getUser(){
        return $this->name;
        return $this->password;
        return $this->email;
    }

}

