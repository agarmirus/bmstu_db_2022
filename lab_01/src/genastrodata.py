import random
import math


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

MIN_PLANET_RADIUS = 2.5e3       # км
MAX_PLANET_RADIUS = 7e4         # км

MIN_PLANET_MASS = 9.6e24        # кг
MAX_PLANET_MASS = 317.8         # кг

MIN_SATELITE_MASS = 3e18        # кг
MAX_SATELITE_MASS = 1.35e23     # кг

MIN_SATELITE_RADIUS = 80        # км
MAX_SATELITE_RADIUS = 2.5e3     # км

MIN_SATELITE_ROTATION = 10      # сут
MAX_SATELITE_ROTATION = 50      # сут

MIN_SATELITES_COUNT = 1
MAX_SATELITES_COUNT = 10

MIN_COMETS_COUNT = 1e3
MAX_COMETS_COUNT = 7e3

MIN_PLANETS_COUNT = 1
MAX_PLANETS_COUNT = 50

STELLAR_CLASSES = list("OBAFGKM")


def gen_galaxies(galaxies: dict):
    names = []

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "GLX" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        galaxy_type = random.choice(GALAXY_TYPES)
        radius = random.uniform(MIN_GALAXY_RADIUS, MAX_GALAXY_RADIUS)
        mass = random.uniform(MIN_GALAXY_MASS, MAX_GALAXY_MASS)
        
        galaxies[i] = [name, galaxy_type, radius, mass]


def gen_planet_systems(planet_systems: dict, galaxies: dict):
    names = []
    galaxies_ids = list(galaxies.keys())

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "PS" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        planets_count = random.randint(MIN_PLANETS_COUNT, MAX_PLANETS_COUNT)
        satelites_count = random.randint(MIN_SATELITES_COUNT, MAX_SATELITES_COUNT)
        comets_count = random.randint(MIN_COMETS_COUNT, MAX_COMETS_COUNT)
        galaxy_id = random.choice(galaxies_ids)

        planet_systems[i] = [name, planets_count, satelites_count, comets_count, galaxy_id]


def gen_stars(stars: dict, planet_systems: dict):
    names = []

    planets_systems_ids = list(planet_systems.keys())
    random.shuffle(planets_systems_ids)

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "S" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        stellar_class = random.choice(STELLAR_CLASSES)

        mass = random.uniform(80, 300)
        temperature = random.uniform(3e4, 6e4)

        if stellar_class == 'B':
            mass = random.uniform(3.1, 18)
            temperature = random.uniform(1e4, 3e4)
        elif stellar_class == 'A':
            mass = random.uniform(1.7, 3.1)
            temperature = random.uniform(7.5e3, 1e4)
        elif stellar_class == 'F':
            mass = random.uniform(1.1, 1.7)
            temperature = random.uniform(6e3, 7.5e3)
        elif stellar_class == 'G':
            mass = random.uniform(0.8, 1.1)
            temperature = random.uniform(5e3, 6e3)
        elif stellar_class == 'K':
            mass = random.uniform(0.3, 0.8)
            temperature = random.uniform(3.5e3, 5e3)
        elif stellar_class == 'M':
            mass = random.uniform(0.077, 0.3)
            temperature = random.uniform(2e3, 3.5e3)
        
        planet_system_id = planets_systems_ids.pop()

        stars[i] = [name, stellar_class, mass, temperature, planet_system_id]


def gen_planets(planets: dict, planet_systems: dict):
    names = []
    planet_systems_counts = {i: [planet_systems[i][1], planet_systems[i][2]] for i in planet_systems}
    planet_systems_ids = list(planet_systems_counts.keys())

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "PL" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        avrg_radius = random.uniform(MIN_PLANET_RADIUS, MAX_PLANET_RADIUS)
        mass = random.uniform(MIN_PLANET_MASS, MAX_PLANET_MASS)

        planet_system_id = random.choice(planet_systems_ids)

        while planet_systems_counts[planet_system_id][0] == 0:
            planet_system_id = random.choice(planet_systems_ids)

        satelites_count = 0

        if planet_systems_counts[planet_system_id][1] <= 1:
            satelites_count = planet_systems_counts[planet_system_id][1]
        else:
            satelites_count = random.randint(1, planet_systems_counts[planet_system_id][1])
        
        planet_systems_counts[planet_system_id][1] -= satelites_count
        planet_systems_counts[planet_system_id][0] -= 1

        planets[i] = [name, avrg_radius, mass, satelites_count, planet_system_id]


def gen_satelites(satelites: dict, planets: dict):
    names = []
    satelites_counts = {i: planets[i][-1] for i in planets}
    planets_ids = list(planets.keys())

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "STL" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        planet_id = random.choice(planets_ids)

        while satelites_counts[planet_id] == 0:
            planet_id = random.choice(planets_ids)
        
        satelites_counts[planet_id] -= 1

        avrg_radius = random.uniform(MIN_SATELITE_RADIUS, MAX_SATELITE_RADIUS)
        mass = random.uniform(MIN_SATELITE_MASS, MAX_SATELITE_MASS)
        rotation_period = random.uniform(MIN_SATELITE_ROTATION, MAX_SATELITE_ROTATION)

        satelites[i] = [name, avrg_radius, mass, rotation_period, planet_id]


def save_galaxies_data(filename: str, data: dict):
    with open(filename, 'w') as fout:
        for i in data:
            print(
                "{},{},{},{:.2E},{:.2E}".format(
                i, data[i][0], data[i][1],
                data[i][2], data[i][3]
                ), file=fout)


def save_planet_systems_data(filename: str, data: dict):
    with open(filename, 'w') as fout:
        for i in data:
            print(i, *data[i], sep=',', file=fout)


def save_stars_data(filename: str, data: dict):
    with open(filename, 'w') as fout:
        for i in data:
            print("{},{},{},{:.2E},{:.2E},{}".format(
                i, data[i][0], data[i][1],
                data[i][2], data[i][3],
                data[i][4]
            ), file=fout)


def save_planets_data(filename: str, data: dict):
    with open(filename, 'w') as fout:
        for i in data:
            print("{},{},{:.2E},{:.2E},{},{}".format(
                i, data[i][0], data[i][1],
                data[i][2], data[i][3],
                data[i][4]
            ), file=fout)


def save_satelites_data(filename: str, data: dict):
    with open(filename, 'w') as fout:
        for i in data:
            print("{},{},{:.2E},{:.2E},{:.2E},{}".format(
                i, data[i][0], data[i][1],
                data[i][2], data[i][3],
                data[i][4]
            ), file=fout)


def main():
    galaxies = dict()
    planet_systems = dict()
    stars = dict()
    planets = dict()
    satelites = dict()

    gen_galaxies(galaxies)
    gen_planet_systems(planet_systems, galaxies)
    gen_stars(stars, planet_systems)
    gen_planets(planets, planet_systems)
    gen_satelites(satelites, planets)

    save_galaxies_data("../data/galaxies.csv", galaxies)
    save_planet_systems_data("../data/planet_systems.csv", planet_systems)
    save_stars_data("../data/stars.csv", stars)
    save_planets_data("../data/planets.csv", planets)
    save_satelites_data("../data/satelites.csv", satelites)


if __name__ == "__main__":
    main()
