package com.talentix.platform.service;

import com.talentix.platform.model.Employee;

import java.util.List;

public interface EmployeeService {

    Employee createEmployee(Employee employee);

    Employee getEmployeeById(Long id);

    List<Employee> getAllEmployees();

    Employee updateEmployee(Long id, Employee employee);

    void deleteEmployee(Long id);

    List<Employee> getEmployeesByDepartment(Long departmentId);

    List<Employee> getEmployeesByJobTitle(String jobTitle);
}