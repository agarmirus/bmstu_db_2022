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

FST_ORG_NAME_PARTS = [
    "International", "Asian",
    "Eurasian", "North American",
    "Europe", "South American",
    "West", "East",
    "North", "South",
]

SND_ORG_NAME_PARTS = [
    "Space", "Astronomical",
    "Research", "Science",
    "Exploration", "Cosmic",
    "Aerospace", "Academic",
    "Scientifically Technical", "Aeronautics"
]

THD_ORG_NAME_PARTS = [
    "Program", "Corporation",
    "Company", "Group",
    "Organization", "Community",
    "Laboratory", "University",
    "Institution", "Association"
]


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


def gen_space_programs(space_programs: dict):
    fst_count = len(FST_ORG_NAME_PARTS)
    snd_count = len(SND_ORG_NAME_PARTS)
    thd_count = len(THD_ORG_NAME_PARTS)

    names = []
    org_id = 1

    for i in range(fst_count):
        for j in range(snd_count):
            for k in range(thd_count):


def main():
    galaxies = dict()

    gen_galaxies(galaxies)

    save_galaxies_data("../data/galaxies.csv", galaxies)


if __name__ == "__main__":
    main()
