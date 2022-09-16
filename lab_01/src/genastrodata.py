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

MIN_GALAXY_RADIUS = 34
MAX_GALAXY_RADIUS = 9e6

MIN_GALAXY_MASS = 55e4
MAX_GALAXY_MASS = 24.528e12

MIN_GALAXY_DISTANCE = 800e3
MAX_GALAXY_DISTANCE = 8e9

STELLAR_CLASSES = list("OBAFGKM")


def gen_galaxies(galaxies: dict):
    names = []

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "G" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        galaxy_type = random.choice(GALAXY_TYPES)
        radius = random.uniform(MIN_GALAXY_RADIUS, MAX_GALAXY_RADIUS)
        mass = random.uniform(MIN_GALAXY_MASS, MAX_GALAXY_MASS)
        absolute_magnitude = random.uniform(-1, 10) - 5 * math.log10(
            10 / random.uniform(MIN_GALAXY_DISTANCE, MAX_GALAXY_DISTANCE
            ))
        
        galaxies[i] = [name, galaxy_type, radius, mass, absolute_magnitude]


def gen_planet_systems(planet_systems: dict, galaxies: dict):
    names = []
    galaxies_ids = list(galaxies.keys())

    for i in range(1, 1001):
        name = ""

        while not name or name in names:
            name = "PS" + str(random.randint(MIN_NAME_NUMBER, MAX_NAME_NUMBER))
        
        names.append(name)

        planets_count = random.randint(1, 10)
        satelites_count = random.randint(1, 3)
        comets_count = random.randint(1e3, 7e3)
        galaxy_id = random.choice(galaxies_ids)

        planet_systems[i] = [name, planets_count, satelites_count, comets_count, galaxy_id]


def gen_stars(stars: dict, planet_systems: dict):
    names = []
    planets_systems_ids = list(planet_systems.keys()).shuffle()

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

        stars[i] = [name, stellar_class, mass, temperature]


def gen_planets(planets: dict, planet_systems: dict, stars: dict):
    pass


def gen_satelites(satelites: dict, planets: dict):
    pass


def main():
    galaxies = dict()
    planet_systems = dict()
    stars = dict()
    planets = dict()
    satelites = dict()

    gen_galaxies(galaxies)
    gen_planet_systems(planet_systems, galaxies)
    gen_stars(stars, planet_systems)
    gen_planets(planets, planet_systems, stars)
    gen_satelites(satelites, planets)

    print(galaxies)

if __name__ == "__main__":
    main()
