MOVIE(title, production_year, country, run_time, major_genre)
    primary key    : {title, production_year}

PERSON(id, first_name, last_name, year_born)
    primary key    : {id}

AWARD(award_name, institution, country)
    primary key    : {award_name}

RESTRICTION_CATEGORY(description, country)
    primary key    : {description, country}

DIRECTOR(id, title, production_year)
    primary key    : {title, production_year}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [id] ⊆ PERSON[id]

WRITER(id, title, production_year, credits)
    primary key    : {id, title, production_year}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [id] ⊆ PERSON[id]

CREW(id, title, production_year, contribution)
    primary key    : {id, title, production_year}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [id] ⊆ PERSON[id]

SCENE(title, production_year, scene_no, description)
    primary key    : {title, production_year, scene_no}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]

ROLE(id, title, production_year, description, credits)
    primary key    : {title, production_year, description}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [id] ⊆ PERSON[id]

RESTRICTION(title, production_year, description, country)
    primary key    : {title, production_year, description, country}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [description, country] ⊆ RESTRICTION_CATEGORY[description, country]

APPEARANCE(title, production_year, description, scene_no)
    primary key    : {title, production_year, description, scene_no}
    foreign keys   : [title, production_year, scene_no] ⊆ SCENE[title, production_year, scene_no]
                     [title, production_year, description] ⊆ ROLE[title, production_year, description]

MOVIE_AWARD(title, production_year, award_name, year_of_award, category, result)
    primary key    : {title, production_year, award_name, year_of_award, category}
    foreign keys   : [title, production_year] ⊆ MOVIE[title, production_year]
                     [award_name] ⊆ AWARD[award_name]

CREW_AWARD(id, title, production_year, award_name, year_of_award, category, result)
    primary key    : {id, title, production_year, award_name, year_of_award, category}
    foreign keys   : [id, title, production_year] ⊆ CREW[id, title, production_year]
                     [award_name] ⊆ AWARD[award_name]

DIRECTOR_AWARD(title, production_year, award_name, year_of_award, category, result)
    primary key    : {title, production_year, award_name, year_of_award, category}
    foreign keys   : [title, production_year] ⊆ DIRECTOR[title, production_year]
                     [award_name] ⊆ AWARD[award_name]

WRITER_AWARD(id, title, production_year, award_name, year_of_award, category, result)
    primary key    : {id, title, production_year, award_name, year_of_award, category}
    foreign keys   : [id, title, production_year] ⊆ WRITER[id, title, production_year]
                     [award_name] ⊆ AWARD[award_name]

ACTOR_AWARD(title, production_year, description, award_name, year_of_award, category, result)
    primary key    : {title, production_year, description, award_name, year_of_award, category}
    foreign keys   : [title, production_year, description] ⊆ ROLE[title, production_year, description]
                     [award_name] ⊆ AWARD[award_name]