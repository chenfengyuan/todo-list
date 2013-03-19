BEGIN;
create sequence tl_items_seq;
create table tl_items (
       item_id INT4 DEFAULT nextval('tl_items_seq'),
       item_todo_state INT4 DEFAULT '0' NOT NULL CHECK (item_todo_state >= 0),
       item_title TEXT DEFAULT '' NOT NULL,
       item_content TEXT DEFAULT '' NOT NULL,
       PRIMARY KEY (item_id)
);
create index tl_items_item_id on tl_items(item_id);
COMMIT;
