--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."group" (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- Name: group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."group" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying(200),
    content text,
    user_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    status boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    group_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."group" (id, name, created_at, updated_at) FROM stdin;
1	Admin	2024-01-07 14:26:41.827399+07	2024-01-07 14:26:41.827399+07
2	Staff	2024-01-07 14:26:41.827399+07	2024-01-07 14:26:41.827399+07
3	Dev	2024-01-07 14:26:41.827399+07	2024-01-07 14:26:41.827399+07
4	Manager	2024-01-07 14:34:50.327707+07	2024-01-07 14:34:50.327707+07
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, title, content, user_id, created_at, updated_at) FROM stdin;
1	Bài viết 1	Nội dung 1	1	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
2	Bài viết 2	Nội dung 2	1	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
3	Bài viết 3	Nội dung 3	1	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
4	Bài viết 4	Nội dung 4	2	2024-01-07 14:56:06.196843+07	2024-01-07 14:56:06.196843+07
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, status, created_at, updated_at, group_id) FROM stdin;
2	User 2	user2@gmail.com	123456	t	2024-01-05 18:58:42.256008+07	2024-01-05 18:58:42.256008+07	1
5	User 5	user5@gmail.com	123456	f	2024-01-05 20:17:57.015+07	2024-01-05 20:17:57.015+07	2
1	User 1	user1@gmail.com	123456	t	2024-01-05 20:17:07.695828+07	2024-01-05 20:17:07.695828+07	1
4	User 4	user4@gmail.com	123456	t	2024-01-05 20:17:43.11512+07	2024-01-05 20:17:43.11512+07	3
3	User 3	user3@gmail.com	123456	f	2024-01-05 18:58:42.256008+07	2024-01-05 18:58:42.256008+07	2
\.


--
-- Name: group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_id_seq', 4, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 4, true);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_id_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_primary PRIMARY KEY (id);


--
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_group_id_foregin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_group_id_foregin FOREIGN KEY (group_id) REFERENCES public."group"(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

