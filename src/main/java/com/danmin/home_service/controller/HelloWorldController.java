package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/hello-world")
@Tag(name = "Hello World Controller")
public class HelloWorldController {

    @GetMapping("/enter-name")
    public String enterName(@RequestParam String name) {
        return "Hello " + name;
    }

}
