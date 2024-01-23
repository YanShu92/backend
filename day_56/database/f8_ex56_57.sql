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
    password character varying(100),
    status_name boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    group_id integer,
    deleted_at timestamp with time zone,
    status integer DEFAULT 0
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
4	Bài viết 4	Nội dung 4	\N	2024-01-07 14:56:06.196843+07	2024-01-07 14:56:06.196843+07
1	Bài viết 1	Nội dung 1	\N	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
2	Bài viết 2	Nội dung 2	\N	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
3	Bài viết 3	Nội dung 3	\N	2024-01-07 14:55:44.072851+07	2024-01-07 14:55:44.072851+07
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, status_name, created_at, updated_at, group_id, deleted_at, status) FROM stdin;
11	user1	user1@gmail.com	1234556	t	2024-01-21 14:10:13.57392+07	2024-01-21 14:10:13.57392+07	\N	\N	0
10	admin	admin@gmail.com	$2b$10$KOui3k0nxw8P7/lbnT4gbePUYzgHUxiHJTiER4p6e1NSsb2yGsqiy	t	2024-01-20 16:08:15.446484+07	2024-01-20 16:08:15.446484+07	\N	\N	1
26	YanShu	thanhvilang1@gmail.com	$2b$10$p5Xr.wCR5VEOTDx8wUs/E.31aRgsz3NJaNhxN/GDlBcD79F.IFvZG	\N	2024-01-23 20:16:29.294+07	2024-01-23 20:16:29.294+07	\N	\N	0
27	YanShu	thanhvilang2@gmail.com	$2b$10$1QW2Ve8cYYeeTw/SAW8v6espB2b.4TYAnbsG7LlklJ77msUgdMLuG	\N	2024-01-23 20:17:32.553+07	2024-01-23 20:17:32.553+07	\N	\N	0
28	YanShu	thanhvilang3@gmail.com	$2b$10$L9H81nA5O.9lUAfyXFWhA.4vVvrCAi5x7nNT6XA1BdtYnZxWKmn9u	\N	2024-01-23 20:31:14.203+07	2024-01-23 20:31:14.203+07	\N	\N	0
24	user19	user19@gmail.com	1231255	t	2024-01-21 16:30:14.893226+07	2024-01-21 16:30:14.893226+07	\N	\N	0
25	YanShu	thanhvilang@gmail.com	$2b$10$.FE6aSiUL/Z8yVdd4synz.ONFfHxUsXl38FhL27aAc05fhkKjtuHy	\N	2024-01-23 20:13:08.921+07	2024-01-23 20:13:08.921+07	\N	\N	1
29	YanShu	user2@gmail.com	$2b$10$UlGfhbN39a.gzuiRGcdGNewkOXJyvF2Vpd/4v.m1/YxBOskmt1GA.	\N	2024-01-23 23:56:52.726+07	2024-01-23 23:56:52.726+07	\N	\N	0
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
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 29, true);


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
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL NOT VALID;


--
-- Name: users users_group_id_foregin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_group_id_foregin FOREIGN KEY (group_id) REFERENCES public."group"(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

