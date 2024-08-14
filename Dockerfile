# 使用一个基础的 JDK 镜像作为构建环境
FROM maven:3.8.5-openjdk-17 AS build

# 设置工作目录
WORKDIR /app

# 将 pom.xml 和 src 目录复制到工作目录
COPY pom.xml .
COPY src ./src
COPY mvnw .
COPY mvnw.cmd .
COPY .mvn/ .mvn/

# # 确保 Maven Wrapper 文件具有执行权限
RUN chmod +x mvnw

# 执行 Maven 构建
RUN ./mvnw clean package

# 使用一个更小的基础镜像作为运行环境
FROM openjdk:17-slim

# 设置工作目录
WORKDIR /app

# 从构建阶段复制 JAR 文件到当前目录
COPY --from=build /app/target/*.jar app.jar

# 暴露应用运行所需的端口
EXPOSE 8080

# 设置默认的启动命令
ENTRYPOINT ["java", "-jar", "app.jar"]
