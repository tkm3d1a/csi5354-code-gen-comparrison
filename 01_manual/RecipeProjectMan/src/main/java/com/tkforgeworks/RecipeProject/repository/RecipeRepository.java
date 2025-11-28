package com.tkforgeworks.RecipeProject.repository;

import com.tkforgeworks.RecipeProject.model.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe,Long> {
}