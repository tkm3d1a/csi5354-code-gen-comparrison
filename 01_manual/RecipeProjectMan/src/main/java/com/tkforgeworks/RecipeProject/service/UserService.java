package com.tkforgeworks.RecipeProject.service;

import com.tkforgeworks.RecipeProject.model.User;
import com.tkforgeworks.RecipeProject.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public User findById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public User update(Long userId, User user) {
        User updateUser = userRepository.findById(userId).orElse(user);

        if(!updateUser.getName().equals(user.getName())) {
            updateUser.setName(user.getName());
        }

        if(!updateUser.getEmail().equals(user.getEmail())) {
            updateUser.setEmail(user.getEmail());
        }

        return userRepository.save(updateUser);
    }

    public User create(User user) {
        return userRepository.save(user);
    }

    public void delete(Long userId) {
        userRepository.deleteById(userId);
    }
}