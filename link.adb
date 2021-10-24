with Ada.Text_IO;
with Ada.Finalization;
with Ada.Unchecked_Deallocation;

procedure link is
   type Node_Type is new Ada.Finalization.Controlled with record
      Value : Integer;
      Next : access Node_Type;
      Self : access Node_Type;
   end record;

   type Node_Access is access all Node_Type;

   overriding procedure Finalize (Item : in out Node_Type);
   procedure Finalize (Item : in out Node_Type) is
      procedure Free is new Ada.Unchecked_Deallocation(Node_Type, Node_Access);
   begin
      Ada.Text_IO.Put_Line ("finalize!!");
      Free (Item.Self);
   end Finalize;


   package IIO is new Ada.Text_IO.Integer_IO (Integer);

   procedure Free is new Ada.Unchecked_Deallocation(Node_Type, Node_Access);

   function Add (Value : in Integer;
                 Prev : in Node_Access)
                 return Node_Access
   is
      Next : constant Node_Access := new Node_Type;
   begin
      Next.Self := Next;
      Next.Value := Value;
      Next.Next := null;
      Prev.Next := Next;
      return Next;
   end Add;

   procedure Doit is
      Root : constant Node_Access := new Node_Type;
      Cur  : Node_Access := Root;
      Next : Node_Access;
   begin
      Cur.Self := Cur;
      Cur.Value := 42;

      Cur := Add(99, Cur);
      Cur := Add(104, Cur);
      Cur := Add(124, Cur);

      Cur := Root;

      while Cur /= null loop
         IIO.Put (Cur.Value);
         Ada.Text_IO.New_Line;
         Next := Cur.Next;
         --Free (Cur);
         Cur := Next;
      end loop;
   end Doit;
begin
   Doit;
end link;
