package com.dipen.k8shelmdeploy.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/home/helm")
public class HomeController {
    @GetMapping
    public String home(){
        return "Welcome from home controller using helm";
    }
}
