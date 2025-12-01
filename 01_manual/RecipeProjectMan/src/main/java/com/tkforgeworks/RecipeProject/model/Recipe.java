package com.tkforgeworks.RecipeProject.model;

import jakarta.persistence.*;

@Entity
public class Recipe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String description;
    private String category;
    private SkillLevel skillLevel;

    @OneToOne
    private User createdBy;

    public Recipe() {}

    public Long getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public String getDescription() {
        return description;
    }
    public String getCategory() {
        return category;
    }
    public SkillLevel getSkillLevel() {
        return skillLevel;
    }
    public User getCreatedBy() {
        return createdBy;
    }

    public void setId(Long id) {
        this.id = id;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public void setSkillLevel(SkillLevel skillLevel) {
        this.skillLevel = skillLevel;
    }
    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "Recipe [id=" + id
                + ", name=" + name
                + ", description=" + description
                + ", category=" + category
                + ", skillLevel=" + skillLevel + "]";
    }
}