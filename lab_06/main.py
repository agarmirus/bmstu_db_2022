import psycopg2 as pypq

def connect_to_db():
    conn = pypq.connect(
        dbname="agarmirus",
        user="agarmirus",
        password="DBornotDB",
        host="127.0.0.1",
        port="5432")
    return conn

def print_menu():
    print("\nМеню:\n")

    print("1. Найти средний возраст всех космонавтов")
    print("2. Найти программы и их спутники, распологающиеся в галактике GLX2560")
    print("3. Вывести рейтинг программ из России по бюджету")
    print("4. Вывести размер таблицы с информацией о спутниках")
    print("5. Выполнить скалярную функцию из 3й ЛР")
    print("6. Выполнить табличную функцию из 3й ЛР")
    print("7. Выполнить хранимую процедуру из 3й ЛР")
    print("8. Вызвать системную функцию")
    print("9. Создать таблицу с руководителями программ")
    print("10. Добавить руководителя")

    print("\n0. Выход\n")

def input_command() -> int:
    cmd = input("Введите комануду: ")

    if cmd.isdigit():
        cmd = int(cmd)
        if cmd >= 0 or cmd <= 10:
            return cmd

    return -1

def convert_to_array(query) -> list:
    pass

def task_1(cur):
    cur.execute("select avg(budget) from space_programs;")
    rec = cur.fetchall()
    print("\nРезультат: ", float(rec[0][0]), sep='')

def task_2(cur):
    cur.execute(
        """
        select spid1 as spid, stltid, glxid
        from 
        (
            select psr.space_program_id as spid1, stlt.id as stltid, stlt.astro_object_id as aoid
            from prog_stlt_rel psr inner join satellites stlt on satellite_id = stlt.id
        ) as spstlt
        inner join
        (
            select space_program_id as spid2, ao.id as aoid, galaxy_id as glxid
            from astro_objects ao inner join prog_obj_rel por on id = astro_object_id
        ) as spglx
        on spid1 = spid2 and spstlt.aoid = spglx.aoid
        where glxid = (select id from galaxies glx where glx.name = 'GLX2560');
        """
    )
    rec = cur.fetchall()

    print("\nРезультат:\n")

    for row in rec:
        print("Space program id:\t", row[0])
        print("Satellite id:\t\t", row[1])
        print("Galaxy id:\t\t", row[2])
        print()

def task_3(cur):
    cur.execute("""
        with russian_cosmonauts as
        (
            select *
            from space_programs
            where country = 'Russia'
        )
        select rank() over(partition by country order by budget desc) as rankplace, *
        from russian_cosmonauts;
        """
    )
    rec = cur.fetchall()

    print("\nРезультат:\n")

    for row in rec:
        print("Place:\t\t\t", row[0])
        print("Space program id:\t", row[2])
        print("Budget:\t\t\t", row[6])
        print()

def task_4(cur):
    cur.execute("""
        select *
        from pg_size_pretty(pg_total_relation_size('satellites'));
        """
    )
    rec = cur.fetchone()

    print("\nРезультат:", rec[0])

def task_5(cur):
    num = int(input("Введите число: "))
    cur.callproc("is_even", [num])

    rec = cur.fetchone()

    print("\nРезультат:", rec[0])

def task_6(cur):
    cur.callproc("get_glx_aos", [835])

    rec = cur.fetchall()

    for row in rec:
        print(row[0], row[1])

def task_7(cur):
    cur.execute("call delete_sp('Kerbal Space Program');")

def task_8(cur):
    cur.callproc("inet_client_addr", [])

    rec = cur.fetchone()

    print("\nРезультат:", rec[0])

def task_9(cur):
    pass

def task_10(cur):
    pass

def execute(cmd: int, cur):
    if cmd == 0:
        return False
    elif cmd == 1:
        task_1(cur)
    elif cmd == 2:
        task_2(cur)
    elif cmd == 3:
        task_3(cur)
    elif cmd == 4:
        task_4(cur)
    elif cmd == 5:
        task_5(cur)
    elif cmd == 6:
        task_6(cur)
    elif cmd == 7:
        task_7(cur)
    elif cmd == 8:
        task_8(cur)
    elif cmd == 9:
        task_9(cur)
    elif cmd == 10:
        task_10(cur)
    
    return True

def main():
    conn = connect_to_db()
    cur = conn.cursor()

    running = True
    
    while running:
        print_menu()
        cmd = input_command()

        if cmd == -1:
            print("Неккоректная команда")
        else:
            running = execute(cmd, cur)
            conn.commit()


if __name__ == "__main__":
    main()
