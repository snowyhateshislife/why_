import Array "mo:base/Array";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

import User "user";
actor {
    public type User = User.users;
    private var users = HashMap.HashMap<Principal, User>(1,Principal.equal, Principal.hash);
    private stable var usersEntries : [(Principal, User)] = [];

    private stable var userList : [User] = [];
    public shared ({caller}) func CreateAccount(firstname : Text, lastname : Text, sex : Bool, birthdate : Text, phone : Text, address : Text) : async Text{
      switch(users.get(caller)) {
        case(null){
          var newAccount : User = {
            firstname = firstname;
            lastname =lastname;
            sex =  sex;
            birthdate =  birthdate;
            phone = phone;
            address = address; 
          };   
          users.put(caller, newAccount);
          userList := Array.append<User>(userList, [newAccount]);
          usersEntries := Array.append<(Principal, User)>(usersEntries, [(caller, newAccount)]);
          return "You've successfully create a new account."
        };
        case (_) {
          return ("You've already create your account.");
        };
      };
    };



    public shared ({caller}) func test() : async ?User{
      return users.remove(caller);
      };

    public func returnList() : async [User]{
      return userList;
      };

public func returndata() : async [(Principal, User)] {
  return usersEntries;
};
  public shared ({caller}) func updateAccount(firstname : Text, lastname : Text, sex : Bool, birthdate : Text, phone : Text, address : Text) : async Text {
    var newAccount : User = {
            firstname = firstname;
            lastname =lastname;
            sex =  sex;
            birthdate =  birthdate;
            phone = phone;
            address = address; 
          };
    switch(users.replace(caller, newAccount)) {
        case(null){
            return "You haven't create an account yet.";
          };   
        case(_){
            userList := await updateList((users.get(caller)), newAccount);
            usersEntries := await updateData([(caller, users.get(caller))],[(caller,newAccount)]);
            return "You've updated your user data.";
        };


      };
      };
    
  public shared ({caller}) func removeAccount() : async Text {
    var test : ?User = users.get(caller);
    switch(users.remove(caller)){
      case(null) {
        return "You have not create an account yet.";
      };
      case(_) {
        userList := await deleteList(test);
        usersEntries := await deleteData([(caller,test)]);
        return "You've successfully delete your account";
      }
    };
  };

  public func deleteList(target : ?User) : async [User]{
    var new_array : [User] = [];
    for (i in userList.vals()) {
      if(i != target) {
        new_array := Array.append<User>(new_array, [i]);
      };
    };
    return new_array;
  };

  public shared ({caller}) func deleteData(target : [(Principal,?User)]) : async [(Principal, User)] {
    var new_array : [(Principal,User)] = [];
    for (i in (userList.vals())) {
      if([(caller,i)] != target) {
        new_array := Array.append<(Principal,User)>(new_array, [(caller,i)]);
      };
    };
    return new_array;
    };
  public func resetList() : async () {userList := []; usersEntries :=[]; };
  
  public func updateList(target : ?User, newAccount : User) : async [User]{
    var new_array : [User] = [];
    for (i in userList.vals()) {
      if(i != target) {
        new_array := Array.append<User>(new_array, [i]);
      } else {
        new_array := Array.append<User>(new_array, [newAccount]);
      };
    };
    return new_array;
  };
  
  public shared ({caller}) func updateData(target : [(Principal,?User)], newData : [(Principal,User)]) : async [(Principal, User)] {
    var new_array : [(Principal,User)] = [];
    for (i in (userList.vals())) {
      if([(caller,i)] != target) {
        new_array := Array.append<(Principal,User)>(new_array, [(caller,i)]);
      } else {
        new_array := Array.append<(Principal,User)>(new_array, newData);
      }
    };
    return new_array;
    };
  }

