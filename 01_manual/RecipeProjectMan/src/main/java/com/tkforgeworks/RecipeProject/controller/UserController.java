package com.tkforgeworks.RecipeProject.controller;

import com.tkforgeworks.RecipeProject.model.User;
import com.tkforgeworks.RecipeProject.service.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {
    private final UserService userService;
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<User> findAll() {
        return userService.findAll();
    }

    @GetMapping("/{userId}")
    public User findById(@PathVariable("userId") Long userId) {
        return userService.findById(userId);
    }

    @PutMapping("/{userId}")
    public User update(@PathVariable("userId") Long userId, @RequestBody User user) {
        return userService.update(userId, user);
    }

    @PostMapping
    public User create(@RequestBody User user) {
        return userService.create(user);
    }

    @DeleteMapping("/{userId}")
    public void delete(@PathVariable("userId") Long userId) {
        userService.delete(userId);
    }
}