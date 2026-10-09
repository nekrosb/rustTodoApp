use std::env;
use std::fs::{self, OpenOptions};
use std::io::{self, Write};
use std::path::Path;

fn main() {
    let dir_path = String::from("todos");
    let file_path: String = format!("{}/todo.txt", dir_path);

    if !Path::new(&dir_path).exists() {
        fs::create_dir_all(&dir_path).expect("Failed to create directory");
    }

    let arguments: Vec<String> = env::args().collect();

    if arguments.len() == 1 {
        write_todo(&file_path);
    } else if arguments.contains(&"--view".to_string()) || arguments.contains(&"--list".to_string())
    {
        read_todos(&file_path);
    }
}

fn read_todos(file_path: &str) {
    let todos = match fs::read_to_string(file_path) {
        Ok(todos) => todos,
        Err(error) if error.kind() == io::ErrorKind::NotFound => {
            println!("No todo items found.");
            return;
        }
        Err(error) => panic!("Failed to read todo file: {error}"),
    };

    if todos.trim().is_empty() {
        println!("No todo items found.");
        return;
    }

    println!("Todo items:");
    for (index, todo) in todos.lines().enumerate() {
        println!("{}. {todo}", index + 1);
    }
}

fn write_todo(file_path: &str) {
    println!("Please enter a todo item:");
    let todo = loop {
        let mut input = String::new();

        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        if !input.trim().is_empty() {
            break input.trim().to_string();
        }

        println!("Please enter a non-empty todo item.");
    };

    println!("You entered: ({todo}) does it correct? (y/n)");
    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("Failed to read line");

    if input.trim() == "y" {
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(file_path)
            .expect("Failed to open file");

        writeln!(file, "{todo}").expect("Failed to write to file");

        println!("Todo item saved.");
    } else {
        println!("Todo item not saved.");
    }
}
