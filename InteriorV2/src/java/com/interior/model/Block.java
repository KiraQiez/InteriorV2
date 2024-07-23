package com.interior.model;

public class Block {
    private String ID;
    private String name;
    private int capacity;

    // default
    public Block() {
        this.ID = "";
        this.name = "";
        this.capacity = 0;
    }

    // normal
    public Block(String ID, String name, int capacity) {
        this.ID = ID;
        this.name = name;
        this.capacity = capacity;
    }

    // setter
    public void setID(String ID) {
        this.ID = ID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    // getter
    public String getID() {
        return ID;
    }

    public String getName() {
        return name;
    }

    public int getCapacity() {
        return capacity;
    }

    public String toString() {
        return "Block{" + "ID=" + ID + ", name=" + name + ", capacity=" + capacity + '}';
    }
}
