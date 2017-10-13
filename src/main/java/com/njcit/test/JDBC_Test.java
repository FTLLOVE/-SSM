package com.njcit.test;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class JDBC_Test {
    private static Connection connection;

    public static void main(String[] args) {
        InputStream resourceAsStream = JDBC_Test.class.getClassLoader().getResourceAsStream("JDBC.properties");
        Properties properties = new Properties();
        try {
            String sql = "INSERT INTO tbl_dept (dept_id,dept_name) VALUES (101,'开发部')";
            properties.load(resourceAsStream);
            String driver = properties.getProperty("driver");
            String url = properties.getProperty("url");
            String username = properties.getProperty("username");
            String password = properties.getProperty("password");
            // 加载驱动url
            Class.forName(driver);
            // 获取连接
            connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            statement.execute(sql);

        } catch (IOException e) {

        } catch (ClassNotFoundException e) {

        } catch (SQLException e) {

        } finally {
            try {
                connection.close();
            } catch (SQLException e) {

            }

        }


    }
}