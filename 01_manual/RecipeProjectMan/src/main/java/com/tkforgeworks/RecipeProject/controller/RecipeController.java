package com.tkforgeworks.RecipeProject.controller;

import com.tkforgeworks.RecipeProject.model.Recipe;
import com.tkforgeworks.RecipeProject.service.RecipeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/recipes")
public class RecipeController {
    private final RecipeService recipeService;

    public RecipeController(RecipeService recipeService) {
        this.recipeService = recipeService;
    }

    @GetMapping
    public List<Recipe> findAll() {
        return recipeService.findAll();
    }

    @GetMapping("/{recipeId}")
    public Recipe findById(@PathVariable("recipeId") Long recipeId) {
        return recipeService.findById(recipeId);
    }

    @PutMapping("/{recipeId}")
    public Recipe update(@PathVariable("recipeId") Long recipeId, @RequestBody Recipe recipe) {
        return recipeService.updateById(recipeId, recipe);
    }

    @PostMapping
    public Recipe create(@RequestBody Recipe recipe) {
        return recipeService.create(recipe);
    }

    @DeleteMapping("/{recipeId}")
    public void delete(@PathVariable("recipeId") Long recipeId) {
        recipeService.delete(recipeId);
    }
}