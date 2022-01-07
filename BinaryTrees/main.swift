//
//  main.swift
//  BinaryTrees
//
//  Created by Ben Garrison on 1/4/22.
//

import Foundation

//MARK: TODO -> Add actual unit tests!


/*
 Binary trees have a downward "tree" structure, with nodes splitting off like leaves. Trees start from the root, and split into left and right children. All branches are just new trees splitting off of the tree above. This is a recursive structure.
 
 MARK: Terms to know. Full, Perfect, Balanced. Ordered. Recursive. O(log n) (half/half/half). Depth vs Breadth. Depth: Inorder, Preorder, Postoeder. Great for searching!
 
 ex      o  <- this tree is "full" : every branch ends in 0 or 2 child nodes
        / \
       o   o
      / \ / \
     o  o o  o
    / \
   o   o
 
         o  <- this tree is not "full" : it has an uneven branch on the right
        / \
       o   o
      / \   \
     o  o    o
 
         o  <- this tree is "perfect" : all branches are perfectly balanced
        / \
       o   o
      / \ / \
     o  o o  o
 
 A "balanced" binary tree has the minimum possible depth, and is as efficient as possible
 
 ex     ABCDE <- balanced         ABCDE <- unbalanced: h = (n + 1)/2 - 1
       /     \                   /     \
      ABCD    E                 ABCD    E
     /    \                    /    \
    AB    CD                  ABC    D
   /  \  /  \                /   \
  A    B C   D              AB    C
                           /  \
                          A    B
 
 MARK: Ways of searching. Breadth first (search cross-wise): when you suspect the data is near the top. Depth first (search heigh-wise): when you suspect the data is deep in the tree.
 */


//create node
 
 class Node {
     var key: Int = 0
     var left: Node?
     var right: Node?
     
     init(_ key: Int) {
         self.key = key
     }
     
     func height() -> Int {
         if isLeaf {
             return 0
         } else {
             print(left?.height() ?? 0, right?.height() ?? 0)
             return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
         }
     }
     
     //variable to find min
     var min: Node {
         if left == nil {
             return self
         } else {
             return left!.min
         }
     }
     
     var isLeaf: Bool {
         return left == nil && right == nil
     }
 }
 /*
MARK: Binary Search Tree Find
 A binary search tree searches a "sorted" tree. In a sorted tree, all key values of nodes on the left branch are less than the root node (parent), and all keys on the right branch are greater. Do a Less Than, Greater Than search on each node and work down until a null value is hit.
MARK: Binary Search Tree Insert
  When inserting, work down from root and insert according to value of key, following left/right rule of sorted tree
MARK: Binary Search Tree Delete
  Three cases to consider: No Child, One Child, Two Children.
  If no children, you've reached the end. Just set it to null.
  If one child, replace the node you want to delete with it's child (child moves up)
  If two children, follow the right hand path until minimum value is found, use it to replace the node you want to delete, and then set it's original node to null. This is the most complex delete function.
  MARK: Traversing Binary Trees
  Depth first: Inorder, Preorder, Postorder
  ex:  1
      / \
     2   3
  Inorder: 2, 1, 3 (L, Root, R) Used for getting data in order
  Preorder: 1, 2, 3 (Root, L, R) Used for copying tree
  PostOrder: 2, 3, 1 (L, R, Root) Bottom up [used in deletes]
  MARK: memory tricks -> "Pre" = start at Root, "Post" = end at Root, and left always comes before right.
 */

class BinarySearchTree {
    var root: Node?
    
    //note: most functions come in pairs -> private and public
    
    func insert(key: Int) {
        root = insertItem(root, key)
    }
    
    private func insertItem(_ node: Node?, _ key: Int) -> Node {
        guard let node = node else {
            let node = Node(key)
            return node
        }
        
        if key < node.key {
            node.left = insertItem(node.left, key)
        }
        if key > node.key {
            node.right = insertItem(node.right, key)
        }
        
        return node
    }
    
    func find(key: Int) -> Int? {
        guard let root = root else { return nil }
        guard let node = find(root, key) else { return nil }
        
        return node.key
    }
    
    private func find(_ node: Node?, _ key: Int) -> Node? {
        guard let node = node else { return nil }
        
        if node.key == key {
            return node
        } else if key < node.key {
            return find(node.left, key)
        } else if key > node.key {
            return find(node.right, key)
        }
        return nil
        //note: duplicate keys are not allowed (unlike hash tables), so no need to check
    }
    
    func findMin() -> Int {
        //only traverses left branches until it hits null
        guard let root = root else { return 0 }
        return findMin(root).key
    }
    
    private func findMin(_ node: Node) -> Node {
        return node.min
    }
    
    func delete(key: Int) {
        guard let _ = root else { return }
        root = delete(&root, key)
        //note: ampersand is a pointer, being used with inout function to pass by reference
    }
    
    private func delete(_ node: inout Node?, _ key: Int) -> Node? {
    guard let nd = node else { return nil }
    
    if key < nd.key {
        nd.left = delete(&nd.left, key)
    } else if key > nd.key {
        nd.right = delete(&nd.right, key)
    } else {
        //case 1: no child
        if nd.left == nil && nd.right == nil {
            node = nil
        }
        //case 2: one child
        else if nd.left == nil {
            node = nd.right
        }
        else if nd.right == nil {
            node = nd.left
        }
        //case 3: two children
        else {
            //find min node on right (or max on left)
            let minRight = findMin(nd.right!)
        
            //duplicate it by copying it's value
            node!.key = minRight.key
            
            //delete the duplicated node
            node!.right = delete(&node!.right, node!.key)
            }
        }
    return nil
    }
    
    func printInOrderTravseral() { inOrderTraversal(node: root) }
        
        func inOrderTraversal(node: Node?) {
            guard let node = node else { return }
            inOrderTraversal(node: node.left)
            print(node.key) // root
            inOrderTraversal(node: node.right)
        }
        
        func printPreOrderTravseral() { preOrderTraversal(node: root) }
        
        func preOrderTraversal(node: Node?) {
            guard let node = node else { return }
            print(node.key) // root
            preOrderTraversal(node: node.left)
            preOrderTraversal(node: node.right)
        }

        func printPostOrderTravseral() { postOrderTraversal(node: root) }
        
        func postOrderTraversal(node: Node?) {
            guard let node = node else { return }
            postOrderTraversal(node: node.left)
            postOrderTraversal(node: node.right)
            print(node.key) // root
        }
}


print("")
print("Values after inserting into binary search tree:")
let binarySearchTree = BinarySearchTree()

binarySearchTree.insert(key: 5)
binarySearchTree.insert(key: 3)
binarySearchTree.insert(key: 2)
binarySearchTree.insert(key: 4)
binarySearchTree.insert(key: 7)
binarySearchTree.insert(key: 6)
binarySearchTree.insert(key: 8)

print(binarySearchTree.find(key: 5) ?? 0)
print(binarySearchTree.find(key: 3) ?? 0)
print(binarySearchTree.find(key: 2) ?? 0)
print(binarySearchTree.find(key: 4) ?? 0)
print(binarySearchTree.find(key: 7) ?? 0)
print(binarySearchTree.find(key: 6) ?? 0)
print(binarySearchTree.find(key: 8) ?? 0)

print(binarySearchTree.findMin())

//MARK: Algo Questions.

print("")
print("Algo questions start here:")


/*
 MARK: Question 1, is this a Binary Search Tree?
 - Does it contain no duplicates?
 - Is it ordered with greater values on the right and lesser values on the left?
 */

//Note building from Node class found above (around line 50)
//Using In-Order traversal

func checkBST(node: Node?, lastValue: inout Int?) -> Bool {
    guard let node = node else { return true }
    
  //lastValue of previous traversal must be <= current value
    if let previousValue = lastValue, previousValue > node.key { return false }
    
   //visit left
    if !checkBST(node: node.left, lastValue: &lastValue) { return false }
    
    //compare and visit self
    if let leftValue = lastValue, leftValue > node.key { return false }
    lastValue = node.key
    
    //visit right
    if !checkBST(node: node.right, lastValue: &lastValue) { return false }
    
    return true
}

/*
 MARK: You will be expected to build out basic trees in a coding interview!
 Build out some trees to test with:
 https://medium.com/swift-solutions/check-if-a-binary-tree-is-a-binary-search-tree-af41e989049
*/

print("")
print("Good BST:")
var root = Node(3)
root.left = Node(2)
root.right = Node(4)
root.left?.left = Node(1)
root.right?.right = Node(5)
var lastValue: Int? = nil
print("")
print("This is a true Binary Search Tree: \(checkBST(node: root, lastValue: &lastValue)).")
print("")

print("Bad BST:")
root = Node(3)
root.left = Node(2)
root.right = Node(4)
root.left?.left = Node(6)
root.right?.right = Node(5)
print("This is a true Binary Search Tree: \(checkBST(node: root, lastValue: &lastValue)).")
print("")
    
print("Duplicate value BST")
root = Node(3)
root.left = Node(2)
root.right = Node(4)
root.left?.left = Node(1)
root.right?.right = Node(1)
print("This is a true Binary Search Tree: \(checkBST(node: root, lastValue: &lastValue)).")
print("")

/*
 Question 2: find the height of a binary tree:
 MARK: Start from zero, like an array!
 Can build a function in Node class to do this, but building it out in code below.
 */

//Slightly different naming conventions

class Tree {
    var x: Int = 0
    var l: Tree?
    var r: Tree?
    
    init(_ key: Int) {
        self.x = key
    }
}

func solution(_ T: Tree?) -> Int {
    return height(T!)
}

func isLeaf(_ tree: Tree?) -> Bool {
    return tree?.l == nil && tree?.r == nil
}

func height(_ tree: Tree?) -> Int {
    if isLeaf(tree) {
        return 0
    } else {
        return 1 + max(height(tree?.l ?? nil), height(tree?.r ?? nil))
    }
}

print("BST height answers:")
var leaf = Tree(5)
leaf.l = Tree(3)
leaf.r = Tree(10)
leaf.l?.l = Tree(20)
leaf.l?.r = Tree(21)
leaf.r?.l = Tree(1)
print("This tree's height is: \(solution(leaf))")

leaf = Tree(4)
leaf.l = Tree(3)
leaf.r = Tree(10)
leaf.l?.l = Tree(20)
leaf.l?.r = Tree(21)
leaf.r?.l = Tree(1)
leaf.r?.r = Tree(15)
leaf.r?.r?.r = Tree(30)
leaf.r?.r?.r?.l = Tree(12)

print("This tree's height is: \(solution(leaf))")
print("")

/*
 Question 3: lowest common ancestor
 */



