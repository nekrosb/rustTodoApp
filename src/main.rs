use std::fs::{self, OpenOptions};
use std::io::{self, Write};
use std::path::Path;

fn main() {
    let dir_path = String::from("todos");
    let file_path: String = format!("{}/todo.txt", dir_path);

    if !Path::new(&dir_path).exists() {
        fs::create_dir_all(&dir_path).expect("Failed to create directory");
    }

    write_todo(&file_path);
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
