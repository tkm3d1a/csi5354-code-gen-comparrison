# Repository Overview

This repository houses the 3 versions of code being written to research and test the efficacy of code generation tools for modern Spring based Java applications.

[01_manual](./01_manual/): Contains all manually written code and statistics for this code.  This is considered the baseline that all other code generation output will be compared against.

[02_star-uml](./02_star-uml/): Contains all output and statistics for code generation completed through StarUML.

[03_papyrus](./03_papyrus/): Contains all output and statistics for code generation completed through Eclipse Papyrus.

## Baseline UML outline

Below is the overall class diagram that will be recreated in both StarUML and Papyrus.  This class diagram is reverse engineered based on the final Manual code written as that is the acting baseline for this research.

Note that this diagram is meant for reference only, not all elements will be strictly used based on the capabilities of the simplest code generation components of each tool.  It will also be restructured into a package format for each tool to facilitate directory structure generation.  Overall time to recreate each model will be used as an additional comparison point to give quantitative data on the user experience for each tool.

```mermaid
classDiagram
    %% Model/Domain Classes
    class User {
        -Long id
        -String name
        -String email
        +getId() Long
        +setId(Long) void
        +getName() String
        +setName(String) void
        +getEmail() String
        +setEmail(String) void
        +toString() String
    }

    class Recipe {
        -Long id
        -String name
        -String description
        -String category
        -SkillLevel skillLevel
        -User createdBy
        +Recipe()
        +getId() Long
        +setId(Long) void
        +getName() String
        +setName(String) void
        +getDescription() String
        +setDescription(String) void
        +getCategory() String
        +setCategory(String) void
        +getSkillLevel() SkillLevel
        +setSkillLevel(SkillLevel) void
        +getCreatedBy() User
        +setCreatedBy(User) void
        +toString() String
    }

    class SkillLevel {
        <<enumeration>>
        PRO
        HOME_CHEF
        LINE_COOK
        AMATEUR
    }

    %% Repository Layer
    class RecipeRepository {
        <<interface>>
    }

    class UserRepository {
        <<interface>>
    }

    class JpaRepository~T,ID~ {
        <<interface>>
        +findAll() List~T~
        +findById(ID) Optional~T~
        +save(T) T
        +deleteById(ID) void
    }

    %% Service Layer
    class RecipeService {
        -RecipeRepository recipeRepository
        +RecipeService(RecipeRepository)
        +findAll() List~Recipe~
        +findById(Long) Recipe
        +updateById(Long, Recipe) Recipe
        +create(Recipe) Recipe
        +delete(Long) void
    }

    class UserService {
        -UserRepository userRepository
        +UserService(UserRepository)
        +findAll() List~User~
        +findById(Long) User
        +update(Long, User) User
        +create(User) User
        +delete(Long) void
    }

    %% Controller Layer
    class RecipeController {
        -RecipeService recipeService
        +RecipeController(RecipeService)
        +findAll() List~Recipe~
        +findById(Long) Recipe
        +update(Long, Recipe) Recipe
        +create(Recipe) Recipe
        +delete(Long) void
    }

    class UserController {
        -UserService userService
        +UserController(UserService)
        +findAll() List~User~
        +findById(Long) User
        +update(Long, User) User
        +create(User) User
        +delete(Long) void
    }

    %% Relationships
    Recipe "1" --> "1" SkillLevel : skillLevel
    Recipe "1" --> "0..1" User : createdBy

    RecipeRepository --|> JpaRepository : extends
    UserRepository --|> JpaRepository : extends

    RecipeService --> RecipeRepository : uses
    UserService --> UserRepository : uses

    RecipeController --> RecipeService : uses
    UserController --> UserService : uses

    RecipeService ..> Recipe : manages
    UserService ..> User : manages
    RecipeController ..> Recipe : handles
    UserController ..> User : handles
```

## Additional tools used

For the various line counts and other metrics collected on the final generated code, a script was developed to automatically count and extract different metrics from each code base.  This is built with the intention of being use din a Debian based linux distribution and is contained in the [04_tool-scripts](./04_tool-scripts/) folder.
