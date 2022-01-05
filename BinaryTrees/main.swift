//
//  main.swift
//  BinaryTrees
//
//  Created by Ben Garrison on 1/4/22.
//

import Foundation

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
 
 ex     ABCDE <- balanced         ABCDE <- unbalanced: h = (n +1)/2 - 1
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
     
     //variable to find min
     var min: Node {
         if left == nil {
             return self
         } else {
             return left!.min
         }
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
        return 0
    }
    
    private func findMin(_ node: Node) -> Node {
        return Node(0)
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

//binarySearchTree.delete(key: 2)

print(binarySearchTree.find(key: 5) ?? 0)
print(binarySearchTree.find(key: 3) ?? 0)
print(binarySearchTree.find(key: 2) ?? 0)
print(binarySearchTree.find(key: 4) ?? 0)
print(binarySearchTree.find(key: 7) ?? 0)
print(binarySearchTree.find(key: 6) ?? 0)
print(binarySearchTree.find(key: 8) ?? 0)

print(binarySearchTree.findMin())

//print("")
//print("Values after deleting keys 3, 4, 7, 8:")
//
//binarySearchTree.delete(key: 3)
//binarySearchTree.delete(key: 4)
//binarySearchTree.delete(key: 7)
//binarySearchTree.delete(key: 8)
//
//print(binarySearchTree.find(key: 5) ?? 0)
//print(binarySearchTree.find(key: 3) ?? 0)
//print(binarySearchTree.find(key: 2) ?? 0)
//print(binarySearchTree.find(key: 4) ?? 0)
//print(binarySearchTree.find(key: 7) ?? 0)
//print(binarySearchTree.find(key: 6) ?? 0)
//print(binarySearchTree.find(key: 8) ?? 0)


