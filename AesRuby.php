<?php

namespace App\RestBundle\Lib;
use \Exception;

class AesRuby
{


    private $iv; #Same as in ruby
    private $key; #Same as in ruby
    private $cipher_method;

    function __construct($key,$iv)
    {
        $this->key = $key;
        $this->iv=$iv;
        $this->cipher_method= 'AES-128-CBC';
    }
    function encrypt($str) {
        $iv_length = openssl_cipher_iv_length($this->cipher_method);
        $iv = $this->iv;
        $str = $iv.$str;
        $val = openssl_encrypt($str, $this->cipher_method, $this->key, 0, $iv);
        return str_replace(array('+', '/', '='), array('_', '-', '.'), $val);
    }
    function decrypt($str) {
        $val = str_replace(array('_','-', '.'), array('+', '/', '='), $str);
        $data = base64_decode($val);
        $iv_length = openssl_cipher_iv_length($this->cipher_method);
        $body_data = substr($data, $iv_length);
        $iv = substr($data, 0, $iv_length);
        $base64_body_data = base64_encode($body_data);
        return openssl_decrypt($base64_body_data, $this->cipher_method, $this->key, 0, $iv);
    }
}
?>