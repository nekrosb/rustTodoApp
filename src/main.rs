use std::io;

fn main() {
    write_todo();
}

fn write_todo() {
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

    println!("You entered: {}", todo);
}
