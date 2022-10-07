from mimesis import Person, Address
import random


MIN_NAME_NUMBER = 1
MAX_NAME_NUMBER = 5000

GALAXY_TYPES = [
    "Спиральная",
    "Эллиптическая",
    "Линзообразная",
    "Спиральная с перемычкой",
    "Неправильная"
]

MIN_GALAXY_RADIUS = 34          # пк
MAX_GALAXY_RADIUS = 9e6         # пк

MIN_GALAXY_MASS = 55e4          # M солнца
MAX_GALAXY_MASS = 24.528e12     # M солнца

MIN_YEAR = 1980
MAX_YEAR = 2010

MIN_WORKERS_COUNT = 100
MAX_WORKERS_COUNT = 1000

MIN_BUDGET = int(1e6)
MAX_BUDGET = int(1e8)

MIN_SATELLITE_PRICE = int(1e6)
MAX_SATELLITE_PRICE = int(5e8)

MIN_SATELLITE_CREATION_YEAR = 2010
MAX_SATELLITE_CREATION_YEAR = 2022

SATELITE_TYPES = [
    "Астрономический", "Биоспутник", "Зондирования"
]

MAX_LAUNCH_PERIOD = 2

MAX_SND_KEYS_COUNT = 5

MIN_DISCOVERY_YEAR = 1920
MAX_DISCOVERY_YEAR = 1980

ASTRO_OBJECT_TYPES = [
    "Планета земного типа", "Звезда",
    "Газовый гигант", "Карликовая планета",
    "Ледяной гигант", "Экзопланета"
]

MIN_ASTRO_OBJ_DISTANCE = 1.3
MAX_ASTRO_OBJ_DISTANCE = 10

MIN_COSMONAUT_MASS = 60
MAX_COSMONAUT_MASS = 90

MIN_BIRTH_YEAR = 1960
MAX_BIRTH_YEAR = 1990

COMPANY_INFIXES = [
    "Space", "Astronomical",
    "Exploration", "Science"
]

COMPANY_TYPES = [
    "Company", "Agency",
    "Program", "Corporation",
    "Institution"
]


def gen_galaxies(galaxies: dict):
    names = []

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "GLX" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))

        names.append(name)

        galaxy_type = random.choice(GALAXY_TYPES)
        radius = round(random.uniform(MIN_GALAXY_RADIUS, MAX_GALAXY_RADIUS), 3)
        mass = round(random.uniform(MIN_GALAXY_MASS, MAX_GALAXY_MASS), 3)

        galaxies[i] = [name, galaxy_type, radius, mass]


def gen_space_programs(space_programs: dict):
    names = []

    person = Person()
    address = Address()

    for i in range(1, 1001):
        name = person.last_name() + " " + random.choice(COMPANY_INFIXES) + " " + random.choice(COMPANY_TYPES)

        names.append(name)

        year = random.randint(MIN_YEAR, MAX_YEAR)
        workers_count = random.randint(MIN_WORKERS_COUNT, MAX_WORKERS_COUNT)
        country = address.country()
        budget = random.randint(MIN_BUDGET, MAX_BUDGET)

        space_programs[i] = [name, year, workers_count, country, budget]


def gen_satellites(satellites: dict, astro_objects: dict):
    names = []
    astro_objects_ids = list(astro_objects.keys())

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "S" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))

        names.append(name)

        stlt_type = random.choice(SATELITE_TYPES)
        price = random.randint(MIN_SATELLITE_PRICE, MAX_SATELLITE_PRICE)
        creation_year = random.randint(MIN_SATELLITE_CREATION_YEAR, MAX_SATELLITE_CREATION_YEAR)
        launch_year = creation_year + random.randint(0, MAX_LAUNCH_PERIOD)
        astro_object_id = random.choice(astro_objects_ids)

        satellites[i] = [name, stlt_type, price, creation_year, launch_year, astro_object_id]


def gen_astro_objects(astro_objects: dict, galaxies: dict):
    names = []

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "A" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))

        names.append(name)

        astro_obj_type = random.choice(ASTRO_OBJECT_TYPES)
        discovery_year = random.randint(MIN_DISCOVERY_YEAR, MAX_DISCOVERY_YEAR)
        distance = round(random.uniform(MIN_ASTRO_OBJ_DISTANCE, MAX_ASTRO_OBJ_DISTANCE), 3)
        galaxy_id = random.choice(list(galaxies.keys()))

        astro_objects[i] = [name, astro_obj_type, discovery_year, distance, galaxy_id]


def gen_cosmonauts(cosmonauts: dict, space_programs: dict):
    person = Person('en')

    for i in range(1, 1001):
        name = person.full_name()

        birth_year = random.randint(MIN_BIRTH_YEAR, MAX_BIRTH_YEAR)
        mass = random.randint(MIN_COSMONAUT_MASS, MAX_COSMONAUT_MASS)
        growth = mass + random.randint(90, 110)
        space_program_id = random.choice(list(space_programs.keys()))

        cosmonauts[i] = [name, birth_year, mass, growth, space_program_id]


def gen_relationships(
        stlt_prog_rel: list,
        prog_obj_rel: list,
        satellites: dict,
        space_programs: dict
):
    space_programs_ids = list(space_programs.keys())

    for satellite_id in satellites.keys():
        astro_object_id = satellites[satellite_id][-1]
        marked_space_programs = []

        for j in range(1, random.randint(2, 10)):
            space_program_id = random.choice(space_programs_ids)

            while space_program_id in marked_space_programs:
                space_program_id = random.choice(space_programs_ids)

            prog_stlt = [space_program_id, satellite_id]
            prog_obj = [space_program_id, astro_object_id]

            stlt_prog_rel.append(prog_stlt)

            if prog_obj not in prog_obj_rel:
                prog_obj_rel.append(prog_obj)


def save_data(filename: str, data):
    with open(filename, 'w') as file:
        if type(data) == list:
            for pair in data:
                print(*pair, sep=';', file=file)
        else:
            for i in data.keys():
                print(i, *data[i], sep=';', file=file)


def main():
    galaxies = dict()
    space_programs = dict()
    satellites = dict()
    stlt_prog_rel = list()
    astro_objects = dict()
    obj_prog_rel = list()
    cosmonauts = dict()

    gen_galaxies(galaxies)
    gen_astro_objects(astro_objects, galaxies)
    gen_space_programs(space_programs)
    gen_satellites(satellites, astro_objects)
    gen_cosmonauts(cosmonauts, space_programs)
    gen_relationships(stlt_prog_rel, obj_prog_rel, satellites, space_programs)

    save_data("../data/galaxies.csv", galaxies)
    save_data("../data/space_programs.csv", space_programs)
    save_data("../data/satellites.csv", satellites)
    save_data("../data/prog_stlt_rel.csv", stlt_prog_rel)
    save_data("../data/astro_objects.csv", astro_objects)
    save_data("../data/prog_obj_rel.csv", obj_prog_rel)
    save_data("../data/cosmonauts.csv", cosmonauts)


if __name__ == "__main__":
    main()
