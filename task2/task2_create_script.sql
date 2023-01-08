CREATE TYPE skill_level AS ENUM('beginner', 'intermediate', 'advanced');
CREATE TYPE lesson_type AS ENUM('individual', 'group', 'ensemble');

CREATE TABLE contact_person (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 email VARCHAR(500),
 home_phone VARCHAR(500),
 mobile_phone VARCHAR(500)
);

ALTER TABLE contact_person ADD CONSTRAINT PK_contact_person PRIMARY KEY (id);


CREATE TABLE instructor (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_number VARCHAR(12) UNIQUE,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 eligible_for_ensemble BOOLEAN,
 city VARCHAR(500),
 zip VARCHAR(500),
 street VARCHAR(500)
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (id);


CREATE TABLE instructor_email (
 instructor_id INT NOT NULL,
 email VARCHAR(500) NOT NULL
);

ALTER TABLE instructor_email ADD CONSTRAINT PK_instructor_email PRIMARY KEY (instructor_id,email);


CREATE TABLE instructor_payment (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instructor_id INT NOT NULL,
 total_amount INT,
 due_date DATE
);

ALTER TABLE instructor_payment ADD CONSTRAINT PK_instructor_payment PRIMARY KEY (id);


CREATE TABLE instructor_phone_number (
 instructor_id INT NOT NULL,
 phone_number VARCHAR(500) NOT NULL
);

ALTER TABLE instructor_phone_number ADD CONSTRAINT PK_instructor_phone_number PRIMARY KEY (instructor_id,phone_number);


CREATE TABLE instrument_type (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 type_name VARCHAR(500) UNIQUE,
 description VARCHAR(500)
);

ALTER TABLE instrument_type ADD CONSTRAINT PK_instrument_type PRIMARY KEY (id);


CREATE TABLE pricing (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 lesson_type lesson_type,
 skill_level skill_level ,
 price INT,
 instructor_compensation INT
);

ALTER TABLE pricing ADD CONSTRAINT PK_pricing PRIMARY KEY (id);


CREATE TABLE student (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_number VARCHAR(12) UNIQUE,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 city VARCHAR(500),
 zip VARCHAR(500),
 street VARCHAR(500),
 contact_person_id INT,
 sibling_group_id INT
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE student_email (
 email VARCHAR(500) NOT NULL,
 student_id INT NOT NULL
);

ALTER TABLE student_email ADD CONSTRAINT PK_student_email PRIMARY KEY (email,student_id);


CREATE TABLE student_payment (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 student_id INT NOT NULL,
 total_amount INT,
 due_date DATE,
 sibling_discount BOOLEAN
);

ALTER TABLE student_payment ADD CONSTRAINT PK_student_payment PRIMARY KEY (id);


CREATE TABLE student_phone_number (
 phone_number VARCHAR(500) NOT NULL,
 student_id INT NOT NULL
);

ALTER TABLE student_phone_number ADD CONSTRAINT PK_student_phone_number PRIMARY KEY (phone_number,student_id);


CREATE TABLE instructor_instrument_type (
 instrument_type_id INT NOT NULL,
 instructor_id INT NOT NULL
);

ALTER TABLE instructor_instrument_type ADD CONSTRAINT PK_instructor_instrument_type PRIMARY KEY (instrument_type_id,instructor_id);


CREATE TABLE instrument (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_type_id INT NOT NULL,
 brand VARCHAR(500),
 available_for_rental BOOLEAN,
 monthly_price INT
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (id);


CREATE TABLE lesson (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 pricing_id INT NOT NULL,
 instructor_id INT,
 room VARCHAR(500),
 start_time TIMESTAMP(6),
 end_time TIMESTAMP(6),
 lesson_type lesson_type,
 skill_level skill_level,
 instrument_type_id INT,
 minimum_students INT,
 maximum_students INT,
 genre VARCHAR(500)
);

ALTER TABLE lesson ADD CONSTRAINT PK_lesson PRIMARY KEY (id);


CREATE TABLE lesson_student (
 student_id INT NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE lesson_student ADD CONSTRAINT PK_lesson_student PRIMARY KEY (student_id,lesson_id);


CREATE TABLE rental (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_id INT NOT NULL,
 student_id INT NOT NULL,
 start_date DATE,
 end_date DATE
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (id);


ALTER TABLE instructor_email ADD CONSTRAINT FK_instructor_email_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE instructor_payment ADD CONSTRAINT FK_instructor_payment_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE instructor_phone_number ADD CONSTRAINT FK_instructor_phone_number_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (contact_person_id) REFERENCES contact_person (id);


ALTER TABLE student_email ADD CONSTRAINT FK_student_email_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE student_payment ADD CONSTRAINT FK_student_payment_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE student_phone_number ADD CONSTRAINT FK_student_phone_number_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE instructor_instrument_type ADD CONSTRAINT FK_instructor_instrument_type_0 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (id);
ALTER TABLE instructor_instrument_type ADD CONSTRAINT FK_instructor_instrument_type_1 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE instrument ADD CONSTRAINT FK_instrument_0 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (id);


ALTER TABLE lesson ADD CONSTRAINT FK_lesson_0 FOREIGN KEY (pricing_id) REFERENCES pricing (id) ON DELETE SET NULL;
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (id) ON DELETE SET NULL;
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_2 FOREIGN KEY (instrument_type_id) REFERENCES instrument_type (id) ON DELETE SET NULL;


ALTER TABLE lesson_student ADD CONSTRAINT FK_lesson_student_0 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;
ALTER TABLE lesson_student ADD CONSTRAINT FK_lesson_student_1 FOREIGN KEY (lesson_id) REFERENCES lesson (id) ON DELETE CASCADE;


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (instrument_id) REFERENCES instrument (id) ON DELETE CASCADE;
ALTER TABLE rental ADD CONSTRAINT FK_rental_1 FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE;


