package com.tkforgeworks.RecipeProject.service;

import com.tkforgeworks.RecipeProject.model.Recipe;
import com.tkforgeworks.RecipeProject.repository.RecipeRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RecipeService {

    private final RecipeRepository recipeRepository;

    public RecipeService(RecipeRepository recipeRepository) {
        this.recipeRepository = recipeRepository;
    }


    public List<Recipe> findAll() {
        return recipeRepository.findAll();
    }

    public Recipe findById(Long recipeId) {
        return recipeRepository.findById(recipeId).orElse(null);
    }

    public Recipe updateById(Long recipeId, Recipe recipe) {
        Recipe updateRecipe = recipeRepository.findById(recipeId).orElse(recipe);

        if(!updateRecipe.getName().equals(recipe.getName())) {
            updateRecipe.setName(recipe.getName());
        }

        if(!updateRecipe.getDescription().equals(recipe.getDescription())) {
            updateRecipe.setDescription(recipe.getDescription());
        }

        if(!updateRecipe.getCategory().equals(recipe.getCategory())) {
            updateRecipe.setCategory(recipe.getCategory());
        }

        if(!updateRecipe.getSkillLevel().equals(recipe.getSkillLevel())) {
            updateRecipe.setSkillLevel(recipe.getSkillLevel());
        }

        return recipeRepository.save(updateRecipe);

    }

    public Recipe create(Recipe recipe) {
        return recipeRepository.save(recipe);
    }

    public void delete(Long recipeId) {
        recipeRepository.deleteById(recipeId);
    }
}