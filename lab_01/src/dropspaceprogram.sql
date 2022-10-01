delete from prog_obj_rel
where space_program_id = 342;

delete from prog_stlt_rel
where space_program_id = 342;

update cosmonauts
set space_program_id = null
where space_program_id = 342;

delete from space_programs
where id = 342;
