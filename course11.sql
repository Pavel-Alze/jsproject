toc.dat                                                                                             0000600 0004000 0002000 00000054163 14444623724 0014462 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP       0    '                {            course    15.3    15.3 Q    P           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         Q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         R           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         S           1262    25466    course    DATABASE     �   CREATE DATABASE course WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE course;
                postgres    false         Z           1247    25468    labels    TYPE     O   CREATE TYPE public.labels AS ENUM (
    'none',
    'like',
    'blacklist'
);
    DROP TYPE public.labels;
       public          postgres    false         �            1259    25475    marks    TABLE     }   CREATE TABLE public.marks (
    user_id integer NOT NULL,
    place_id integer NOT NULL,
    label public.labels NOT NULL
);
    DROP TABLE public.marks;
       public         heap    postgres    false    858         �            1259    25478    places    TABLE     �   CREATE TABLE public.places (
    id integer NOT NULL,
    title character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    pointlan double precision NOT NULL,
    pointlon double precision NOT NULL
);
    DROP TABLE public.places;
       public         heap    postgres    false         �            1259    25481    blacklist_places    VIEW     	  CREATE VIEW public.blacklist_places AS
 SELECT places.id,
    places.title,
    places.description,
    marks.user_id,
    marks.place_id
   FROM public.places,
    public.marks
  WHERE ((marks.label = 'blacklist'::public.labels) AND (marks.place_id = places.id));
 #   DROP VIEW public.blacklist_places;
       public          postgres    false    214    214    214    215    215    215    858         �            1255    25485    find_blacklist(integer)    FUNCTION     �   CREATE FUNCTION public.find_blacklist(uid integer) RETURNS SETOF public.blacklist_places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from blacklist_places where user_id = uid;
end; 
$$;
 2   DROP FUNCTION public.find_blacklist(uid integer);
       public          postgres    false    216         �            1259    25486    like_places    VIEW     �   CREATE VIEW public.like_places AS
 SELECT places.id,
    places.title,
    places.description,
    marks.user_id,
    marks.place_id
   FROM public.places,
    public.marks
  WHERE ((marks.label = 'like'::public.labels) AND (marks.place_id = places.id));
    DROP VIEW public.like_places;
       public          postgres    false    215    214    214    214    215    215    858         �            1255    25490    find_like(integer)    FUNCTION     �   CREATE FUNCTION public.find_like(uid integer) RETURNS SETOF public.like_places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from like_places where user_id = uid;
end; 
$$;
 -   DROP FUNCTION public.find_like(uid integer);
       public          postgres    false    217         �            1255    25491    get_all_places(integer)    FUNCTION     �   CREATE FUNCTION public.get_all_places(uid integer) RETURNS SETOF public.places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from places where id not in (select place_id from blacklist_places where user_id = uid);
end; $$;
 2   DROP FUNCTION public.get_all_places(uid integer);
       public          postgres    false    215         �            1259    25492    reviews    TABLE     �   CREATE TABLE public.reviews (
    id integer NOT NULL,
    title character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    user_id integer NOT NULL,
    place_id integer NOT NULL
);
    DROP TABLE public.reviews;
       public         heap    postgres    false         �            1255    25495    get_reviews_byplace(integer)    FUNCTION     �   CREATE FUNCTION public.get_reviews_byplace(pid integer) RETURNS SETOF public.reviews
    LANGUAGE plpgsql
    AS $$
begin
return query select * from reviews where place_id = pid;
end; $$;
 7   DROP FUNCTION public.get_reviews_byplace(pid integer);
       public          postgres    false    218         �            1255    25496    get_reviews_byuser(integer)    FUNCTION     �   CREATE FUNCTION public.get_reviews_byuser(uid integer) RETURNS SETOF public.reviews
    LANGUAGE plpgsql
    AS $$
begin
return query select * from reviews where user_id = uid;
end; $$;
 6   DROP FUNCTION public.get_reviews_byuser(uid integer);
       public          postgres    false    218         �            1255    25581    label_func()    FUNCTION     ?  CREATE FUNCTION public.label_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if new.label = 'none'then
delete from marks where user_id = new.user_id and place_id = new.place_id;
return null;
end if;
if new.label = 'like' then
return new;
end if;
if new.label = 'blacklist' then
return new;
end if;
end;
$$;
 #   DROP FUNCTION public.label_func();
       public          postgres    false         T           0    0    FUNCTION label_func()    ACL     5   GRANT ALL ON FUNCTION public.label_func() TO userdb;
          public          postgres    false    235         �            1255    25498 *   set_label(integer, integer, public.labels) 	   PROCEDURE     �   CREATE PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels)
    LANGUAGE plpgsql
    AS $$
begin
update marks set label=p_label where user_id = u_id and place_id = p_id;
end; 
$$;
 ]   DROP PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels);
       public          postgres    false    858         U           0    0 O   PROCEDURE set_label(IN u_id integer, IN p_id integer, IN p_label public.labels)    ACL     o   GRANT ALL ON PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels) TO userdb;
          public          postgres    false    234         �            1259    25499 	   easypases    TABLE     d   CREATE TABLE public.easypases (
    id integer NOT NULL,
    pass character varying(30) NOT NULL
);
    DROP TABLE public.easypases;
       public         heap    postgres    false         V           0    0    TABLE easypases    ACL     0   GRANT ALL ON TABLE public.easypases TO admindb;
          public          postgres    false    219         �            1259    25502    easypases_id_seq    SEQUENCE     �   CREATE SEQUENCE public.easypases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.easypases_id_seq;
       public          postgres    false    219         W           0    0    easypases_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.easypases_id_seq OWNED BY public.easypases.id;
          public          postgres    false    220         X           0    0    SEQUENCE easypases_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.easypases_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.easypases_id_seq TO admindb;
          public          postgres    false    220         �            1259    25503    logins    TABLE     �   CREATE TABLE public.logins (
    id integer NOT NULL,
    login character varying(30) NOT NULL,
    password character varying(255) NOT NULL
);
    DROP TABLE public.logins;
       public         heap    postgres    false         �            1259    25506    logins_id_seq    SEQUENCE     �   CREATE SEQUENCE public.logins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.logins_id_seq;
       public          postgres    false    221         Y           0    0    logins_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.logins_id_seq OWNED BY public.logins.id;
          public          postgres    false    222         Z           0    0    SEQUENCE logins_id_seq    ACL        GRANT SELECT,USAGE ON SEQUENCE public.logins_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.logins_id_seq TO admindb;
          public          postgres    false    222         �            1259    25507    places_id_seq    SEQUENCE     �   CREATE SEQUENCE public.places_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.places_id_seq;
       public          postgres    false    215         [           0    0    places_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;
          public          postgres    false    223         \           0    0    SEQUENCE places_id_seq    ACL        GRANT SELECT,USAGE ON SEQUENCE public.places_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.places_id_seq TO admindb;
          public          postgres    false    223         �            1259    25508    reviews_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reviews_id_seq;
       public          postgres    false    218         ]           0    0    reviews_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
          public          postgres    false    224         ^           0    0    SEQUENCE reviews_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.reviews_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.reviews_id_seq TO admindb;
          public          postgres    false    224         �            1259    25509    tokens    TABLE     �   CREATE TABLE public.tokens (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    user_id integer NOT NULL,
    login_id integer NOT NULL
);
    DROP TABLE public.tokens;
       public         heap    postgres    false         _           0    0    TABLE tokens    ACL     \   GRANT DELETE ON TABLE public.tokens TO userdb;
GRANT ALL ON TABLE public.tokens TO admindb;
          public          postgres    false    225         `           0    0    COLUMN tokens.token    ACL     6   GRANT SELECT(token) ON TABLE public.tokens TO userdb;
          public          postgres    false    225    3423         a           0    0    COLUMN tokens.user_id    ACL     8   GRANT SELECT(user_id) ON TABLE public.tokens TO userdb;
          public          postgres    false    225    3423         �            1259    25512    tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tokens_id_seq;
       public          postgres    false    225         b           0    0    tokens_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;
          public          postgres    false    226         c           0    0    SEQUENCE tokens_id_seq    ACL        GRANT SELECT,USAGE ON SEQUENCE public.tokens_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.tokens_id_seq TO admindb;
          public          postgres    false    226         �            1259    25513    users    TABLE       CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    phone character varying(12) NOT NULL,
    email character varying(40) NOT NULL,
    age smallint NOT NULL,
    login_id integer NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false         d           0    0    TABLE users    ACL     Z   GRANT SELECT ON TABLE public.users TO userdb;
GRANT ALL ON TABLE public.users TO admindb;
          public          postgres    false    227         �            1259    25516    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    227         e           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    228         f           0    0    SEQUENCE users_id_seq    ACL     }   GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO admindb;
          public          postgres    false    228         �           2604    25517    easypases id    DEFAULT     l   ALTER TABLE ONLY public.easypases ALTER COLUMN id SET DEFAULT nextval('public.easypases_id_seq'::regclass);
 ;   ALTER TABLE public.easypases ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219         �           2604    25518 	   logins id    DEFAULT     f   ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);
 8   ALTER TABLE public.logins ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221         �           2604    25519 	   places id    DEFAULT     f   ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);
 8   ALTER TABLE public.places ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    215         �           2604    25520 
   reviews id    DEFAULT     h   ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
 9   ALTER TABLE public.reviews ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    218         �           2604    25521 	   tokens id    DEFAULT     f   ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);
 8   ALTER TABLE public.tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225         �           2604    25522    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227         D          0    25499 	   easypases 
   TABLE DATA                 public          postgres    false    219       3396.dat F          0    25503    logins 
   TABLE DATA                 public          postgres    false    221       3398.dat A          0    25475    marks 
   TABLE DATA                 public          postgres    false    214       3393.dat B          0    25478    places 
   TABLE DATA                 public          postgres    false    215       3394.dat C          0    25492    reviews 
   TABLE DATA                 public          postgres    false    218       3395.dat J          0    25509    tokens 
   TABLE DATA                 public          postgres    false    225       3402.dat L          0    25513    users 
   TABLE DATA                 public          postgres    false    227       3404.dat g           0    0    easypases_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.easypases_id_seq', 1564, true);
          public          postgres    false    220         h           0    0    logins_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.logins_id_seq', 20, true);
          public          postgres    false    222         i           0    0    places_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.places_id_seq', 5, true);
          public          postgres    false    223         j           0    0    reviews_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);
          public          postgres    false    224         k           0    0    tokens_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.tokens_id_seq', 38, true);
          public          postgres    false    226         l           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 20, true);
          public          postgres    false    228         �           2606    25524    easypases easypases_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.easypases
    ADD CONSTRAINT easypases_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.easypases DROP CONSTRAINT easypases_pkey;
       public            postgres    false    219         �           2606    25526    logins logins_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.logins DROP CONSTRAINT logins_pkey;
       public            postgres    false    221         �           2606    25528    marks mark_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_pkey PRIMARY KEY (user_id, place_id);
 9   ALTER TABLE ONLY public.marks DROP CONSTRAINT mark_pkey;
       public            postgres    false    214    214         �           2606    25530    places places_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.places DROP CONSTRAINT places_pkey;
       public            postgres    false    215         �           2606    25532    reviews reviews_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_pkey;
       public            postgres    false    218         �           2606    25534    tokens tokens_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.tokens DROP CONSTRAINT tokens_pkey;
       public            postgres    false    225         �           2606    25536    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    227         �           1259    25537    pass_inx    INDEX     =   CREATE INDEX pass_inx ON public.easypases USING hash (pass);
    DROP INDEX public.pass_inx;
       public            postgres    false    219         �           2620    25582    marks label_trg    TRIGGER     s   CREATE TRIGGER label_trg BEFORE UPDATE OF label ON public.marks FOR EACH ROW EXECUTE FUNCTION public.label_func();
 (   DROP TRIGGER label_trg ON public.marks;
       public          postgres    false    214    235    214         �           2606    25539    marks mark_place    FK CONSTRAINT     {   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_place FOREIGN KEY (place_id) REFERENCES public.places(id) NOT VALID;
 :   ALTER TABLE ONLY public.marks DROP CONSTRAINT mark_place;
       public          postgres    false    215    214    3229         �           2606    25544    marks mark_user    FK CONSTRAINT     x   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;
 9   ALTER TABLE ONLY public.marks DROP CONSTRAINT mark_user;
       public          postgres    false    3240    214    227         �           2606    25549    reviews review_place    FK CONSTRAINT        ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT review_place FOREIGN KEY (place_id) REFERENCES public.places(id) NOT VALID;
 >   ALTER TABLE ONLY public.reviews DROP CONSTRAINT review_place;
       public          postgres    false    3229    218    215         �           2606    25554    reviews review_user    FK CONSTRAINT     |   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT review_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;
 =   ALTER TABLE ONLY public.reviews DROP CONSTRAINT review_user;
       public          postgres    false    3240    218    227         �           2606    25559    tokens token_login    FK CONSTRAINT     }   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT token_login FOREIGN KEY (login_id) REFERENCES public.logins(id) NOT VALID;
 <   ALTER TABLE ONLY public.tokens DROP CONSTRAINT token_login;
       public          postgres    false    225    3236    221         �           2606    25564    tokens token_user    FK CONSTRAINT     z   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT token_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;
 ;   ALTER TABLE ONLY public.tokens DROP CONSTRAINT token_user;
       public          postgres    false    227    225    3240         �           2606    25569    users user_login    FK CONSTRAINT     {   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_login FOREIGN KEY (login_id) REFERENCES public.logins(id) NOT VALID;
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT user_login;
       public          postgres    false    227    3236    221                                                                                                                                                                                                                                                                                                                                                                                                                     3396.dat                                                                                            0000600 0004000 0002000 00000307454 14444623724 0014305 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.easypases (id, pass) VALUES (1, '123456');
INSERT INTO public.easypases (id, pass) VALUES (2, 'password');
INSERT INTO public.easypases (id, pass) VALUES (3, '12345678');
INSERT INTO public.easypases (id, pass) VALUES (4, 'qwerty');
INSERT INTO public.easypases (id, pass) VALUES (5, '123456789');
INSERT INTO public.easypases (id, pass) VALUES (6, '12345');
INSERT INTO public.easypases (id, pass) VALUES (7, '1234');
INSERT INTO public.easypases (id, pass) VALUES (8, '111111');
INSERT INTO public.easypases (id, pass) VALUES (9, '1234567');
INSERT INTO public.easypases (id, pass) VALUES (10, 'dragon');
INSERT INTO public.easypases (id, pass) VALUES (11, '123123');
INSERT INTO public.easypases (id, pass) VALUES (12, 'baseball');
INSERT INTO public.easypases (id, pass) VALUES (13, 'abc123');
INSERT INTO public.easypases (id, pass) VALUES (14, 'football');
INSERT INTO public.easypases (id, pass) VALUES (15, 'monkey');
INSERT INTO public.easypases (id, pass) VALUES (16, 'letmein');
INSERT INTO public.easypases (id, pass) VALUES (17, '696969');
INSERT INTO public.easypases (id, pass) VALUES (18, 'shadow');
INSERT INTO public.easypases (id, pass) VALUES (19, 'master');
INSERT INTO public.easypases (id, pass) VALUES (20, '666666');
INSERT INTO public.easypases (id, pass) VALUES (21, 'qwertyuiop');
INSERT INTO public.easypases (id, pass) VALUES (22, '123321');
INSERT INTO public.easypases (id, pass) VALUES (23, 'mustang');
INSERT INTO public.easypases (id, pass) VALUES (24, '1234567890');
INSERT INTO public.easypases (id, pass) VALUES (25, 'michael');
INSERT INTO public.easypases (id, pass) VALUES (26, '654321');
INSERT INTO public.easypases (id, pass) VALUES (27, 'pussy');
INSERT INTO public.easypases (id, pass) VALUES (28, 'superman');
INSERT INTO public.easypases (id, pass) VALUES (29, '1qaz2wsx');
INSERT INTO public.easypases (id, pass) VALUES (30, '7777777');
INSERT INTO public.easypases (id, pass) VALUES (31, 'fuckyou');
INSERT INTO public.easypases (id, pass) VALUES (32, '121212');
INSERT INTO public.easypases (id, pass) VALUES (33, '000000');
INSERT INTO public.easypases (id, pass) VALUES (34, 'qazwsx');
INSERT INTO public.easypases (id, pass) VALUES (35, '123qwe');
INSERT INTO public.easypases (id, pass) VALUES (36, 'killer');
INSERT INTO public.easypases (id, pass) VALUES (37, 'trustno1');
INSERT INTO public.easypases (id, pass) VALUES (38, 'jordan');
INSERT INTO public.easypases (id, pass) VALUES (39, 'jennifer');
INSERT INTO public.easypases (id, pass) VALUES (40, 'zxcvbnm');
INSERT INTO public.easypases (id, pass) VALUES (41, 'asdfgh');
INSERT INTO public.easypases (id, pass) VALUES (42, 'hunter');
INSERT INTO public.easypases (id, pass) VALUES (43, 'buster');
INSERT INTO public.easypases (id, pass) VALUES (44, 'soccer');
INSERT INTO public.easypases (id, pass) VALUES (45, 'harley');
INSERT INTO public.easypases (id, pass) VALUES (46, 'batman');
INSERT INTO public.easypases (id, pass) VALUES (47, 'andrew');
INSERT INTO public.easypases (id, pass) VALUES (48, 'tigger');
INSERT INTO public.easypases (id, pass) VALUES (49, 'sunshine');
INSERT INTO public.easypases (id, pass) VALUES (50, 'iloveyou');
INSERT INTO public.easypases (id, pass) VALUES (51, 'fuckme');
INSERT INTO public.easypases (id, pass) VALUES (52, '2000');
INSERT INTO public.easypases (id, pass) VALUES (53, 'charlie');
INSERT INTO public.easypases (id, pass) VALUES (54, 'robert');
INSERT INTO public.easypases (id, pass) VALUES (55, 'thomas');
INSERT INTO public.easypases (id, pass) VALUES (56, 'hockey');
INSERT INTO public.easypases (id, pass) VALUES (57, 'ranger');
INSERT INTO public.easypases (id, pass) VALUES (58, 'daniel');
INSERT INTO public.easypases (id, pass) VALUES (59, 'starwars');
INSERT INTO public.easypases (id, pass) VALUES (60, 'klaster');
INSERT INTO public.easypases (id, pass) VALUES (61, '112233');
INSERT INTO public.easypases (id, pass) VALUES (62, 'george');
INSERT INTO public.easypases (id, pass) VALUES (63, 'asshole');
INSERT INTO public.easypases (id, pass) VALUES (64, 'computer');
INSERT INTO public.easypases (id, pass) VALUES (65, 'michelle');
INSERT INTO public.easypases (id, pass) VALUES (66, 'jessica');
INSERT INTO public.easypases (id, pass) VALUES (67, 'pepper');
INSERT INTO public.easypases (id, pass) VALUES (68, '1111');
INSERT INTO public.easypases (id, pass) VALUES (69, 'zxcvbn');
INSERT INTO public.easypases (id, pass) VALUES (70, '555555');
INSERT INTO public.easypases (id, pass) VALUES (71, '11111111');
INSERT INTO public.easypases (id, pass) VALUES (72, '131313');
INSERT INTO public.easypases (id, pass) VALUES (73, 'freedom');
INSERT INTO public.easypases (id, pass) VALUES (74, '777777');
INSERT INTO public.easypases (id, pass) VALUES (75, 'pass');
INSERT INTO public.easypases (id, pass) VALUES (76, 'fuck');
INSERT INTO public.easypases (id, pass) VALUES (77, 'maggie');
INSERT INTO public.easypases (id, pass) VALUES (78, '159753');
INSERT INTO public.easypases (id, pass) VALUES (79, 'aaaaaa');
INSERT INTO public.easypases (id, pass) VALUES (80, 'ginger');
INSERT INTO public.easypases (id, pass) VALUES (81, 'princess');
INSERT INTO public.easypases (id, pass) VALUES (82, 'joshua');
INSERT INTO public.easypases (id, pass) VALUES (83, 'cheese');
INSERT INTO public.easypases (id, pass) VALUES (84, 'amanda');
INSERT INTO public.easypases (id, pass) VALUES (85, 'summer');
INSERT INTO public.easypases (id, pass) VALUES (86, 'love');
INSERT INTO public.easypases (id, pass) VALUES (87, 'ashley');
INSERT INTO public.easypases (id, pass) VALUES (88, '6969');
INSERT INTO public.easypases (id, pass) VALUES (89, 'nicole');
INSERT INTO public.easypases (id, pass) VALUES (90, 'chelsea');
INSERT INTO public.easypases (id, pass) VALUES (91, 'biteme');
INSERT INTO public.easypases (id, pass) VALUES (92, 'matthew');
INSERT INTO public.easypases (id, pass) VALUES (93, 'access');
INSERT INTO public.easypases (id, pass) VALUES (94, 'yankees');
INSERT INTO public.easypases (id, pass) VALUES (95, '987654321');
INSERT INTO public.easypases (id, pass) VALUES (96, 'dallas');
INSERT INTO public.easypases (id, pass) VALUES (97, 'austin');
INSERT INTO public.easypases (id, pass) VALUES (98, 'thunder');
INSERT INTO public.easypases (id, pass) VALUES (99, 'taylor');
INSERT INTO public.easypases (id, pass) VALUES (100, 'matrix');
INSERT INTO public.easypases (id, pass) VALUES (101, 'william');
INSERT INTO public.easypases (id, pass) VALUES (102, 'corvette');
INSERT INTO public.easypases (id, pass) VALUES (103, 'hello');
INSERT INTO public.easypases (id, pass) VALUES (104, 'martin');
INSERT INTO public.easypases (id, pass) VALUES (105, 'heather');
INSERT INTO public.easypases (id, pass) VALUES (106, 'secret');
INSERT INTO public.easypases (id, pass) VALUES (107, 'fucker');
INSERT INTO public.easypases (id, pass) VALUES (108, 'merlin');
INSERT INTO public.easypases (id, pass) VALUES (109, 'diamond');
INSERT INTO public.easypases (id, pass) VALUES (110, '1234qwer');
INSERT INTO public.easypases (id, pass) VALUES (111, 'gfhjkm');
INSERT INTO public.easypases (id, pass) VALUES (112, 'hammer');
INSERT INTO public.easypases (id, pass) VALUES (113, 'silver');
INSERT INTO public.easypases (id, pass) VALUES (114, '222222');
INSERT INTO public.easypases (id, pass) VALUES (115, '88888888');
INSERT INTO public.easypases (id, pass) VALUES (116, 'anthony');
INSERT INTO public.easypases (id, pass) VALUES (117, 'justin');
INSERT INTO public.easypases (id, pass) VALUES (118, 'test');
INSERT INTO public.easypases (id, pass) VALUES (119, 'bailey');
INSERT INTO public.easypases (id, pass) VALUES (120, 'q1w2e3r4t5');
INSERT INTO public.easypases (id, pass) VALUES (121, 'patrick');
INSERT INTO public.easypases (id, pass) VALUES (122, 'internet');
INSERT INTO public.easypases (id, pass) VALUES (123, 'scooter');
INSERT INTO public.easypases (id, pass) VALUES (124, 'orange');
INSERT INTO public.easypases (id, pass) VALUES (125, '11111');
INSERT INTO public.easypases (id, pass) VALUES (126, 'golfer');
INSERT INTO public.easypases (id, pass) VALUES (127, 'cookie');
INSERT INTO public.easypases (id, pass) VALUES (128, 'richard');
INSERT INTO public.easypases (id, pass) VALUES (129, 'samantha');
INSERT INTO public.easypases (id, pass) VALUES (130, 'bigdog');
INSERT INTO public.easypases (id, pass) VALUES (131, 'guitar');
INSERT INTO public.easypases (id, pass) VALUES (132, 'jackson');
INSERT INTO public.easypases (id, pass) VALUES (133, 'whatever');
INSERT INTO public.easypases (id, pass) VALUES (134, 'mickey');
INSERT INTO public.easypases (id, pass) VALUES (135, 'chicken');
INSERT INTO public.easypases (id, pass) VALUES (136, 'sparky');
INSERT INTO public.easypases (id, pass) VALUES (137, 'snoopy');
INSERT INTO public.easypases (id, pass) VALUES (138, 'maverick');
INSERT INTO public.easypases (id, pass) VALUES (139, 'phoenix');
INSERT INTO public.easypases (id, pass) VALUES (140, 'camaro');
INSERT INTO public.easypases (id, pass) VALUES (141, 'sexy');
INSERT INTO public.easypases (id, pass) VALUES (142, 'peanut');
INSERT INTO public.easypases (id, pass) VALUES (143, 'morgan');
INSERT INTO public.easypases (id, pass) VALUES (144, 'welcome');
INSERT INTO public.easypases (id, pass) VALUES (145, 'falcon');
INSERT INTO public.easypases (id, pass) VALUES (146, 'cowboy');
INSERT INTO public.easypases (id, pass) VALUES (147, 'ferrari');
INSERT INTO public.easypases (id, pass) VALUES (148, 'samsung');
INSERT INTO public.easypases (id, pass) VALUES (149, 'andrea');
INSERT INTO public.easypases (id, pass) VALUES (150, 'smokey');
INSERT INTO public.easypases (id, pass) VALUES (151, 'steelers');
INSERT INTO public.easypases (id, pass) VALUES (152, 'joseph');
INSERT INTO public.easypases (id, pass) VALUES (153, 'mercedes');
INSERT INTO public.easypases (id, pass) VALUES (154, 'dakota');
INSERT INTO public.easypases (id, pass) VALUES (155, 'arsenal');
INSERT INTO public.easypases (id, pass) VALUES (156, 'eagles');
INSERT INTO public.easypases (id, pass) VALUES (157, 'melissa');
INSERT INTO public.easypases (id, pass) VALUES (158, 'boomer');
INSERT INTO public.easypases (id, pass) VALUES (159, 'booboo');
INSERT INTO public.easypases (id, pass) VALUES (160, 'spider');
INSERT INTO public.easypases (id, pass) VALUES (161, 'nascar');
INSERT INTO public.easypases (id, pass) VALUES (162, 'monster');
INSERT INTO public.easypases (id, pass) VALUES (163, 'tigers');
INSERT INTO public.easypases (id, pass) VALUES (164, 'yellow');
INSERT INTO public.easypases (id, pass) VALUES (165, 'xxxxxx');
INSERT INTO public.easypases (id, pass) VALUES (166, '123123123');
INSERT INTO public.easypases (id, pass) VALUES (167, 'gateway');
INSERT INTO public.easypases (id, pass) VALUES (168, 'marina');
INSERT INTO public.easypases (id, pass) VALUES (169, 'diablo');
INSERT INTO public.easypases (id, pass) VALUES (170, 'bulldog');
INSERT INTO public.easypases (id, pass) VALUES (171, 'qwer1234');
INSERT INTO public.easypases (id, pass) VALUES (172, 'compaq');
INSERT INTO public.easypases (id, pass) VALUES (173, 'purple');
INSERT INTO public.easypases (id, pass) VALUES (174, 'hardcore');
INSERT INTO public.easypases (id, pass) VALUES (175, 'banana');
INSERT INTO public.easypases (id, pass) VALUES (176, 'junior');
INSERT INTO public.easypases (id, pass) VALUES (177, 'hannah');
INSERT INTO public.easypases (id, pass) VALUES (178, '123654');
INSERT INTO public.easypases (id, pass) VALUES (179, 'porsche');
INSERT INTO public.easypases (id, pass) VALUES (180, 'lakers');
INSERT INTO public.easypases (id, pass) VALUES (181, 'iceman');
INSERT INTO public.easypases (id, pass) VALUES (182, 'money');
INSERT INTO public.easypases (id, pass) VALUES (183, 'cowboys');
INSERT INTO public.easypases (id, pass) VALUES (184, '987654');
INSERT INTO public.easypases (id, pass) VALUES (185, 'london');
INSERT INTO public.easypases (id, pass) VALUES (186, 'tennis');
INSERT INTO public.easypases (id, pass) VALUES (187, '999999');
INSERT INTO public.easypases (id, pass) VALUES (188, 'ncc1701');
INSERT INTO public.easypases (id, pass) VALUES (189, 'coffee');
INSERT INTO public.easypases (id, pass) VALUES (190, 'scooby');
INSERT INTO public.easypases (id, pass) VALUES (191, '0000');
INSERT INTO public.easypases (id, pass) VALUES (192, 'miller');
INSERT INTO public.easypases (id, pass) VALUES (193, 'boston');
INSERT INTO public.easypases (id, pass) VALUES (194, 'q1w2e3r4');
INSERT INTO public.easypases (id, pass) VALUES (195, 'fuckoff');
INSERT INTO public.easypases (id, pass) VALUES (196, 'brandon');
INSERT INTO public.easypases (id, pass) VALUES (197, 'yamaha');
INSERT INTO public.easypases (id, pass) VALUES (198, 'chester');
INSERT INTO public.easypases (id, pass) VALUES (199, 'mother');
INSERT INTO public.easypases (id, pass) VALUES (200, 'forever');
INSERT INTO public.easypases (id, pass) VALUES (201, 'johnny');
INSERT INTO public.easypases (id, pass) VALUES (202, 'edward');
INSERT INTO public.easypases (id, pass) VALUES (203, '333333');
INSERT INTO public.easypases (id, pass) VALUES (204, 'oliver');
INSERT INTO public.easypases (id, pass) VALUES (205, 'redsox');
INSERT INTO public.easypases (id, pass) VALUES (206, 'player');
INSERT INTO public.easypases (id, pass) VALUES (207, 'nikita');
INSERT INTO public.easypases (id, pass) VALUES (208, 'knight');
INSERT INTO public.easypases (id, pass) VALUES (209, 'fender');
INSERT INTO public.easypases (id, pass) VALUES (210, 'barney');
INSERT INTO public.easypases (id, pass) VALUES (211, 'midnight');
INSERT INTO public.easypases (id, pass) VALUES (212, 'please');
INSERT INTO public.easypases (id, pass) VALUES (213, 'brandy');
INSERT INTO public.easypases (id, pass) VALUES (214, 'chicago');
INSERT INTO public.easypases (id, pass) VALUES (215, 'badboy');
INSERT INTO public.easypases (id, pass) VALUES (216, 'iwantu');
INSERT INTO public.easypases (id, pass) VALUES (217, 'slayer');
INSERT INTO public.easypases (id, pass) VALUES (218, 'rangers');
INSERT INTO public.easypases (id, pass) VALUES (219, 'charles');
INSERT INTO public.easypases (id, pass) VALUES (220, 'angel');
INSERT INTO public.easypases (id, pass) VALUES (221, 'flower');
INSERT INTO public.easypases (id, pass) VALUES (222, 'bigdaddy');
INSERT INTO public.easypases (id, pass) VALUES (223, 'rabbit');
INSERT INTO public.easypases (id, pass) VALUES (224, 'wizard');
INSERT INTO public.easypases (id, pass) VALUES (225, 'bigdick');
INSERT INTO public.easypases (id, pass) VALUES (226, 'jasper');
INSERT INTO public.easypases (id, pass) VALUES (227, 'enter');
INSERT INTO public.easypases (id, pass) VALUES (228, 'rachel');
INSERT INTO public.easypases (id, pass) VALUES (229, 'chris');
INSERT INTO public.easypases (id, pass) VALUES (230, 'steven');
INSERT INTO public.easypases (id, pass) VALUES (231, 'winner');
INSERT INTO public.easypases (id, pass) VALUES (232, 'adidas');
INSERT INTO public.easypases (id, pass) VALUES (233, 'victoria');
INSERT INTO public.easypases (id, pass) VALUES (234, 'natasha');
INSERT INTO public.easypases (id, pass) VALUES (235, '1q2w3e4r');
INSERT INTO public.easypases (id, pass) VALUES (236, 'jasmine');
INSERT INTO public.easypases (id, pass) VALUES (237, 'winter');
INSERT INTO public.easypases (id, pass) VALUES (238, 'prince');
INSERT INTO public.easypases (id, pass) VALUES (239, 'panties');
INSERT INTO public.easypases (id, pass) VALUES (240, 'marine');
INSERT INTO public.easypases (id, pass) VALUES (241, 'ghbdtn');
INSERT INTO public.easypases (id, pass) VALUES (242, 'fishing');
INSERT INTO public.easypases (id, pass) VALUES (243, 'cocacola');
INSERT INTO public.easypases (id, pass) VALUES (244, 'casper');
INSERT INTO public.easypases (id, pass) VALUES (245, 'james');
INSERT INTO public.easypases (id, pass) VALUES (246, '232323');
INSERT INTO public.easypases (id, pass) VALUES (247, 'raiders');
INSERT INTO public.easypases (id, pass) VALUES (248, '888888');
INSERT INTO public.easypases (id, pass) VALUES (249, 'marlboro');
INSERT INTO public.easypases (id, pass) VALUES (250, 'gandalf');
INSERT INTO public.easypases (id, pass) VALUES (251, 'asdfasdf');
INSERT INTO public.easypases (id, pass) VALUES (252, 'crystal');
INSERT INTO public.easypases (id, pass) VALUES (253, '87654321');
INSERT INTO public.easypases (id, pass) VALUES (254, '12344321');
INSERT INTO public.easypases (id, pass) VALUES (255, 'sexsex');
INSERT INTO public.easypases (id, pass) VALUES (256, 'golden');
INSERT INTO public.easypases (id, pass) VALUES (257, 'blowme');
INSERT INTO public.easypases (id, pass) VALUES (258, 'bigtits');
INSERT INTO public.easypases (id, pass) VALUES (259, '8675309');
INSERT INTO public.easypases (id, pass) VALUES (260, 'panther');
INSERT INTO public.easypases (id, pass) VALUES (261, 'lauren');
INSERT INTO public.easypases (id, pass) VALUES (262, 'angela');
INSERT INTO public.easypases (id, pass) VALUES (263, 'bitch');
INSERT INTO public.easypases (id, pass) VALUES (264, 'spanky');
INSERT INTO public.easypases (id, pass) VALUES (265, 'thx1138');
INSERT INTO public.easypases (id, pass) VALUES (266, 'angels');
INSERT INTO public.easypases (id, pass) VALUES (267, 'madison');
INSERT INTO public.easypases (id, pass) VALUES (268, 'winston');
INSERT INTO public.easypases (id, pass) VALUES (269, 'shannon');
INSERT INTO public.easypases (id, pass) VALUES (270, 'mike');
INSERT INTO public.easypases (id, pass) VALUES (271, 'toyota');
INSERT INTO public.easypases (id, pass) VALUES (272, 'blowjob');
INSERT INTO public.easypases (id, pass) VALUES (273, 'jordan23');
INSERT INTO public.easypases (id, pass) VALUES (274, 'canada');
INSERT INTO public.easypases (id, pass) VALUES (275, 'sophie');
INSERT INTO public.easypases (id, pass) VALUES (276, 'Password');
INSERT INTO public.easypases (id, pass) VALUES (277, 'apples');
INSERT INTO public.easypases (id, pass) VALUES (278, 'dick');
INSERT INTO public.easypases (id, pass) VALUES (279, 'tiger');
INSERT INTO public.easypases (id, pass) VALUES (280, 'razz');
INSERT INTO public.easypases (id, pass) VALUES (281, '123abc');
INSERT INTO public.easypases (id, pass) VALUES (282, 'pokemon');
INSERT INTO public.easypases (id, pass) VALUES (283, 'qazxsw');
INSERT INTO public.easypases (id, pass) VALUES (284, '55555');
INSERT INTO public.easypases (id, pass) VALUES (285, 'qwaszx');
INSERT INTO public.easypases (id, pass) VALUES (286, 'muffin');
INSERT INTO public.easypases (id, pass) VALUES (287, 'johnson');
INSERT INTO public.easypases (id, pass) VALUES (288, 'murphy');
INSERT INTO public.easypases (id, pass) VALUES (289, 'cooper');
INSERT INTO public.easypases (id, pass) VALUES (290, 'jonathan');
INSERT INTO public.easypases (id, pass) VALUES (291, 'liverpoo');
INSERT INTO public.easypases (id, pass) VALUES (292, 'david');
INSERT INTO public.easypases (id, pass) VALUES (293, 'danielle');
INSERT INTO public.easypases (id, pass) VALUES (294, '159357');
INSERT INTO public.easypases (id, pass) VALUES (295, 'jackie');
INSERT INTO public.easypases (id, pass) VALUES (296, '1990');
INSERT INTO public.easypases (id, pass) VALUES (297, '123456a');
INSERT INTO public.easypases (id, pass) VALUES (298, '789456');
INSERT INTO public.easypases (id, pass) VALUES (299, 'turtle');
INSERT INTO public.easypases (id, pass) VALUES (300, 'horny');
INSERT INTO public.easypases (id, pass) VALUES (301, 'abcd1234');
INSERT INTO public.easypases (id, pass) VALUES (302, 'scorpion');
INSERT INTO public.easypases (id, pass) VALUES (303, 'qazwsxedc');
INSERT INTO public.easypases (id, pass) VALUES (304, '101010');
INSERT INTO public.easypases (id, pass) VALUES (305, 'butter');
INSERT INTO public.easypases (id, pass) VALUES (306, 'carlos');
INSERT INTO public.easypases (id, pass) VALUES (307, 'password1');
INSERT INTO public.easypases (id, pass) VALUES (308, 'dennis');
INSERT INTO public.easypases (id, pass) VALUES (309, 'slipknot');
INSERT INTO public.easypases (id, pass) VALUES (310, 'qwerty123');
INSERT INTO public.easypases (id, pass) VALUES (311, 'booger');
INSERT INTO public.easypases (id, pass) VALUES (312, 'asdf');
INSERT INTO public.easypases (id, pass) VALUES (313, '1991');
INSERT INTO public.easypases (id, pass) VALUES (314, 'black');
INSERT INTO public.easypases (id, pass) VALUES (315, 'startrek');
INSERT INTO public.easypases (id, pass) VALUES (316, '12341234');
INSERT INTO public.easypases (id, pass) VALUES (317, 'cameron');
INSERT INTO public.easypases (id, pass) VALUES (318, 'newyork');
INSERT INTO public.easypases (id, pass) VALUES (319, 'rainbow');
INSERT INTO public.easypases (id, pass) VALUES (320, 'nathan');
INSERT INTO public.easypases (id, pass) VALUES (321, 'john');
INSERT INTO public.easypases (id, pass) VALUES (322, '1992');
INSERT INTO public.easypases (id, pass) VALUES (323, 'rocket');
INSERT INTO public.easypases (id, pass) VALUES (324, 'viking');
INSERT INTO public.easypases (id, pass) VALUES (325, 'redskins');
INSERT INTO public.easypases (id, pass) VALUES (326, 'butthead');
INSERT INTO public.easypases (id, pass) VALUES (327, 'asdfghjkl');
INSERT INTO public.easypases (id, pass) VALUES (328, '1212');
INSERT INTO public.easypases (id, pass) VALUES (329, 'sierra');
INSERT INTO public.easypases (id, pass) VALUES (330, 'peaches');
INSERT INTO public.easypases (id, pass) VALUES (331, 'gemini');
INSERT INTO public.easypases (id, pass) VALUES (332, 'doctor');
INSERT INTO public.easypases (id, pass) VALUES (333, 'wilson');
INSERT INTO public.easypases (id, pass) VALUES (334, 'sandra');
INSERT INTO public.easypases (id, pass) VALUES (335, 'helpme');
INSERT INTO public.easypases (id, pass) VALUES (336, 'qwertyui');
INSERT INTO public.easypases (id, pass) VALUES (337, 'victor');
INSERT INTO public.easypases (id, pass) VALUES (338, 'florida');
INSERT INTO public.easypases (id, pass) VALUES (339, 'dolphin');
INSERT INTO public.easypases (id, pass) VALUES (340, 'pookie');
INSERT INTO public.easypases (id, pass) VALUES (341, 'captain');
INSERT INTO public.easypases (id, pass) VALUES (342, 'tucker');
INSERT INTO public.easypases (id, pass) VALUES (343, 'blue');
INSERT INTO public.easypases (id, pass) VALUES (344, 'liverpool');
INSERT INTO public.easypases (id, pass) VALUES (345, 'theman');
INSERT INTO public.easypases (id, pass) VALUES (346, 'bandit');
INSERT INTO public.easypases (id, pass) VALUES (347, 'dolphins');
INSERT INTO public.easypases (id, pass) VALUES (348, 'maddog');
INSERT INTO public.easypases (id, pass) VALUES (349, 'packers');
INSERT INTO public.easypases (id, pass) VALUES (350, 'jaguar');
INSERT INTO public.easypases (id, pass) VALUES (351, 'lovers');
INSERT INTO public.easypases (id, pass) VALUES (352, 'nicholas');
INSERT INTO public.easypases (id, pass) VALUES (353, 'united');
INSERT INTO public.easypases (id, pass) VALUES (354, 'tiffany');
INSERT INTO public.easypases (id, pass) VALUES (355, 'maxwell');
INSERT INTO public.easypases (id, pass) VALUES (356, 'zzzzzz');
INSERT INTO public.easypases (id, pass) VALUES (357, 'nirvana');
INSERT INTO public.easypases (id, pass) VALUES (358, 'jeremy');
INSERT INTO public.easypases (id, pass) VALUES (359, 'suckit');
INSERT INTO public.easypases (id, pass) VALUES (360, 'stupid');
INSERT INTO public.easypases (id, pass) VALUES (361, 'porn');
INSERT INTO public.easypases (id, pass) VALUES (362, 'monica');
INSERT INTO public.easypases (id, pass) VALUES (363, 'elephant');
INSERT INTO public.easypases (id, pass) VALUES (364, 'giants');
INSERT INTO public.easypases (id, pass) VALUES (365, 'jackass');
INSERT INTO public.easypases (id, pass) VALUES (366, 'hotdog');
INSERT INTO public.easypases (id, pass) VALUES (367, 'rosebud');
INSERT INTO public.easypases (id, pass) VALUES (368, 'success');
INSERT INTO public.easypases (id, pass) VALUES (369, 'debbie');
INSERT INTO public.easypases (id, pass) VALUES (370, 'mountain');
INSERT INTO public.easypases (id, pass) VALUES (371, '444444');
INSERT INTO public.easypases (id, pass) VALUES (372, 'xxxxxxxx');
INSERT INTO public.easypases (id, pass) VALUES (373, 'warrior');
INSERT INTO public.easypases (id, pass) VALUES (374, '1q2w3e4r5t');
INSERT INTO public.easypases (id, pass) VALUES (375, 'q1w2e3');
INSERT INTO public.easypases (id, pass) VALUES (376, '123456q');
INSERT INTO public.easypases (id, pass) VALUES (377, 'albert');
INSERT INTO public.easypases (id, pass) VALUES (378, 'metallic');
INSERT INTO public.easypases (id, pass) VALUES (379, 'lucky');
INSERT INTO public.easypases (id, pass) VALUES (380, 'azerty');
INSERT INTO public.easypases (id, pass) VALUES (381, '7777');
INSERT INTO public.easypases (id, pass) VALUES (382, 'shithead');
INSERT INTO public.easypases (id, pass) VALUES (383, 'alex');
INSERT INTO public.easypases (id, pass) VALUES (384, 'bond007');
INSERT INTO public.easypases (id, pass) VALUES (385, 'alexis');
INSERT INTO public.easypases (id, pass) VALUES (386, '1111111');
INSERT INTO public.easypases (id, pass) VALUES (387, 'samson');
INSERT INTO public.easypases (id, pass) VALUES (388, '5150');
INSERT INTO public.easypases (id, pass) VALUES (389, 'willie');
INSERT INTO public.easypases (id, pass) VALUES (390, 'scorpio');
INSERT INTO public.easypases (id, pass) VALUES (391, 'bonnie');
INSERT INTO public.easypases (id, pass) VALUES (392, 'gators');
INSERT INTO public.easypases (id, pass) VALUES (393, 'benjamin');
INSERT INTO public.easypases (id, pass) VALUES (394, 'voodoo');
INSERT INTO public.easypases (id, pass) VALUES (395, 'driver');
INSERT INTO public.easypases (id, pass) VALUES (396, 'dexter');
INSERT INTO public.easypases (id, pass) VALUES (397, '2112');
INSERT INTO public.easypases (id, pass) VALUES (398, 'jason');
INSERT INTO public.easypases (id, pass) VALUES (399, 'calvin');
INSERT INTO public.easypases (id, pass) VALUES (400, 'freddy');
INSERT INTO public.easypases (id, pass) VALUES (401, '212121');
INSERT INTO public.easypases (id, pass) VALUES (402, 'creative');
INSERT INTO public.easypases (id, pass) VALUES (403, '12345a');
INSERT INTO public.easypases (id, pass) VALUES (404, 'sydney');
INSERT INTO public.easypases (id, pass) VALUES (405, 'rush2112');
INSERT INTO public.easypases (id, pass) VALUES (406, '1989');
INSERT INTO public.easypases (id, pass) VALUES (407, 'asdfghjk');
INSERT INTO public.easypases (id, pass) VALUES (408, 'red123');
INSERT INTO public.easypases (id, pass) VALUES (409, 'bubba');
INSERT INTO public.easypases (id, pass) VALUES (410, '4815162342');
INSERT INTO public.easypases (id, pass) VALUES (411, 'passw0rd');
INSERT INTO public.easypases (id, pass) VALUES (412, 'trouble');
INSERT INTO public.easypases (id, pass) VALUES (413, 'gunner');
INSERT INTO public.easypases (id, pass) VALUES (414, 'happy');
INSERT INTO public.easypases (id, pass) VALUES (415, 'fucking');
INSERT INTO public.easypases (id, pass) VALUES (416, 'gordon');
INSERT INTO public.easypases (id, pass) VALUES (417, 'legend');
INSERT INTO public.easypases (id, pass) VALUES (418, 'jessie');
INSERT INTO public.easypases (id, pass) VALUES (419, 'stella');
INSERT INTO public.easypases (id, pass) VALUES (420, 'qwert');
INSERT INTO public.easypases (id, pass) VALUES (421, 'eminem');
INSERT INTO public.easypases (id, pass) VALUES (422, 'arthur');
INSERT INTO public.easypases (id, pass) VALUES (423, 'apple');
INSERT INTO public.easypases (id, pass) VALUES (424, 'nissan');
INSERT INTO public.easypases (id, pass) VALUES (425, 'bullshit');
INSERT INTO public.easypases (id, pass) VALUES (426, 'bear');
INSERT INTO public.easypases (id, pass) VALUES (427, 'america');
INSERT INTO public.easypases (id, pass) VALUES (428, '1qazxsw2');
INSERT INTO public.easypases (id, pass) VALUES (429, 'nothing');
INSERT INTO public.easypases (id, pass) VALUES (430, 'parker');
INSERT INTO public.easypases (id, pass) VALUES (431, '4444');
INSERT INTO public.easypases (id, pass) VALUES (432, 'rebecca');
INSERT INTO public.easypases (id, pass) VALUES (433, 'qweqwe');
INSERT INTO public.easypases (id, pass) VALUES (434, 'garfield');
INSERT INTO public.easypases (id, pass) VALUES (435, '01012011');
INSERT INTO public.easypases (id, pass) VALUES (436, 'beavis');
INSERT INTO public.easypases (id, pass) VALUES (437, '69696969');
INSERT INTO public.easypases (id, pass) VALUES (438, 'jack');
INSERT INTO public.easypases (id, pass) VALUES (439, 'asdasd');
INSERT INTO public.easypases (id, pass) VALUES (440, 'december');
INSERT INTO public.easypases (id, pass) VALUES (441, '2222');
INSERT INTO public.easypases (id, pass) VALUES (442, '102030');
INSERT INTO public.easypases (id, pass) VALUES (443, '252525');
INSERT INTO public.easypases (id, pass) VALUES (444, '11223344');
INSERT INTO public.easypases (id, pass) VALUES (445, 'magic');
INSERT INTO public.easypases (id, pass) VALUES (446, 'apollo');
INSERT INTO public.easypases (id, pass) VALUES (447, 'skippy');
INSERT INTO public.easypases (id, pass) VALUES (448, '315475');
INSERT INTO public.easypases (id, pass) VALUES (449, 'girls');
INSERT INTO public.easypases (id, pass) VALUES (450, 'kitten');
INSERT INTO public.easypases (id, pass) VALUES (451, 'golf');
INSERT INTO public.easypases (id, pass) VALUES (452, 'copper');
INSERT INTO public.easypases (id, pass) VALUES (453, 'braves');
INSERT INTO public.easypases (id, pass) VALUES (454, 'shelby');
INSERT INTO public.easypases (id, pass) VALUES (455, 'godzilla');
INSERT INTO public.easypases (id, pass) VALUES (456, 'beaver');
INSERT INTO public.easypases (id, pass) VALUES (457, 'fred');
INSERT INTO public.easypases (id, pass) VALUES (458, 'tomcat');
INSERT INTO public.easypases (id, pass) VALUES (459, 'august');
INSERT INTO public.easypases (id, pass) VALUES (460, 'buddy');
INSERT INTO public.easypases (id, pass) VALUES (461, 'airborne');
INSERT INTO public.easypases (id, pass) VALUES (462, '1993');
INSERT INTO public.easypases (id, pass) VALUES (463, '1988');
INSERT INTO public.easypases (id, pass) VALUES (464, 'lifehack');
INSERT INTO public.easypases (id, pass) VALUES (465, 'qqqqqq');
INSERT INTO public.easypases (id, pass) VALUES (466, 'brooklyn');
INSERT INTO public.easypases (id, pass) VALUES (467, 'animal');
INSERT INTO public.easypases (id, pass) VALUES (468, 'platinum');
INSERT INTO public.easypases (id, pass) VALUES (469, 'phantom');
INSERT INTO public.easypases (id, pass) VALUES (470, 'online');
INSERT INTO public.easypases (id, pass) VALUES (471, 'xavier');
INSERT INTO public.easypases (id, pass) VALUES (472, 'darkness');
INSERT INTO public.easypases (id, pass) VALUES (473, 'blink182');
INSERT INTO public.easypases (id, pass) VALUES (474, 'power');
INSERT INTO public.easypases (id, pass) VALUES (475, 'fish');
INSERT INTO public.easypases (id, pass) VALUES (476, 'green');
INSERT INTO public.easypases (id, pass) VALUES (477, '789456123');
INSERT INTO public.easypases (id, pass) VALUES (478, 'voyager');
INSERT INTO public.easypases (id, pass) VALUES (479, 'police');
INSERT INTO public.easypases (id, pass) VALUES (480, 'travis');
INSERT INTO public.easypases (id, pass) VALUES (481, '12qwaszx');
INSERT INTO public.easypases (id, pass) VALUES (482, 'heaven');
INSERT INTO public.easypases (id, pass) VALUES (483, 'snowball');
INSERT INTO public.easypases (id, pass) VALUES (484, 'lover');
INSERT INTO public.easypases (id, pass) VALUES (485, 'abcdef');
INSERT INTO public.easypases (id, pass) VALUES (486, '00000');
INSERT INTO public.easypases (id, pass) VALUES (487, 'pakistan');
INSERT INTO public.easypases (id, pass) VALUES (488, '007007');
INSERT INTO public.easypases (id, pass) VALUES (489, 'walter');
INSERT INTO public.easypases (id, pass) VALUES (490, 'playboy');
INSERT INTO public.easypases (id, pass) VALUES (491, 'blazer');
INSERT INTO public.easypases (id, pass) VALUES (492, 'cricket');
INSERT INTO public.easypases (id, pass) VALUES (493, 'sniper');
INSERT INTO public.easypases (id, pass) VALUES (494, 'hooters');
INSERT INTO public.easypases (id, pass) VALUES (495, 'donkey');
INSERT INTO public.easypases (id, pass) VALUES (496, 'willow');
INSERT INTO public.easypases (id, pass) VALUES (497, 'loveme');
INSERT INTO public.easypases (id, pass) VALUES (498, 'saturn');
INSERT INTO public.easypases (id, pass) VALUES (499, 'therock');
INSERT INTO public.easypases (id, pass) VALUES (500, 'redwings');
INSERT INTO public.easypases (id, pass) VALUES (501, '123456');
INSERT INTO public.easypases (id, pass) VALUES (502, 'password');
INSERT INTO public.easypases (id, pass) VALUES (503, '12345678');
INSERT INTO public.easypases (id, pass) VALUES (504, '1234');
INSERT INTO public.easypases (id, pass) VALUES (505, 'pussy');
INSERT INTO public.easypases (id, pass) VALUES (506, '12345');
INSERT INTO public.easypases (id, pass) VALUES (507, 'dragon');
INSERT INTO public.easypases (id, pass) VALUES (508, 'qwerty');
INSERT INTO public.easypases (id, pass) VALUES (509, '696969');
INSERT INTO public.easypases (id, pass) VALUES (510, 'mustang');
INSERT INTO public.easypases (id, pass) VALUES (511, 'letmein');
INSERT INTO public.easypases (id, pass) VALUES (512, 'baseball');
INSERT INTO public.easypases (id, pass) VALUES (513, 'master');
INSERT INTO public.easypases (id, pass) VALUES (514, 'michael');
INSERT INTO public.easypases (id, pass) VALUES (515, 'football');
INSERT INTO public.easypases (id, pass) VALUES (516, 'shadow');
INSERT INTO public.easypases (id, pass) VALUES (517, 'monkey');
INSERT INTO public.easypases (id, pass) VALUES (518, 'abc123');
INSERT INTO public.easypases (id, pass) VALUES (519, 'pass');
INSERT INTO public.easypases (id, pass) VALUES (520, 'fuckme');
INSERT INTO public.easypases (id, pass) VALUES (521, '6969');
INSERT INTO public.easypases (id, pass) VALUES (522, 'jordan');
INSERT INTO public.easypases (id, pass) VALUES (523, 'harley');
INSERT INTO public.easypases (id, pass) VALUES (524, 'ranger');
INSERT INTO public.easypases (id, pass) VALUES (525, 'iwantu');
INSERT INTO public.easypases (id, pass) VALUES (526, 'jennifer');
INSERT INTO public.easypases (id, pass) VALUES (527, 'hunter');
INSERT INTO public.easypases (id, pass) VALUES (528, 'fuck');
INSERT INTO public.easypases (id, pass) VALUES (529, '2000');
INSERT INTO public.easypases (id, pass) VALUES (530, 'test');
INSERT INTO public.easypases (id, pass) VALUES (531, 'batman');
INSERT INTO public.easypases (id, pass) VALUES (532, 'trustno1');
INSERT INTO public.easypases (id, pass) VALUES (533, 'thomas');
INSERT INTO public.easypases (id, pass) VALUES (534, 'tigger');
INSERT INTO public.easypases (id, pass) VALUES (535, 'robert');
INSERT INTO public.easypases (id, pass) VALUES (536, 'access');
INSERT INTO public.easypases (id, pass) VALUES (537, 'love');
INSERT INTO public.easypases (id, pass) VALUES (538, 'buster');
INSERT INTO public.easypases (id, pass) VALUES (539, '1234567');
INSERT INTO public.easypases (id, pass) VALUES (540, 'soccer');
INSERT INTO public.easypases (id, pass) VALUES (541, 'hockey');
INSERT INTO public.easypases (id, pass) VALUES (542, 'killer');
INSERT INTO public.easypases (id, pass) VALUES (543, 'george');
INSERT INTO public.easypases (id, pass) VALUES (544, 'sexy');
INSERT INTO public.easypases (id, pass) VALUES (545, 'andrew');
INSERT INTO public.easypases (id, pass) VALUES (546, 'charlie');
INSERT INTO public.easypases (id, pass) VALUES (547, 'superman');
INSERT INTO public.easypases (id, pass) VALUES (548, 'asshole');
INSERT INTO public.easypases (id, pass) VALUES (549, 'fuckyou');
INSERT INTO public.easypases (id, pass) VALUES (550, 'dallas');
INSERT INTO public.easypases (id, pass) VALUES (551, 'jessica');
INSERT INTO public.easypases (id, pass) VALUES (552, 'panties');
INSERT INTO public.easypases (id, pass) VALUES (553, 'pepper');
INSERT INTO public.easypases (id, pass) VALUES (554, '1111');
INSERT INTO public.easypases (id, pass) VALUES (555, 'austin');
INSERT INTO public.easypases (id, pass) VALUES (556, 'william');
INSERT INTO public.easypases (id, pass) VALUES (557, 'daniel');
INSERT INTO public.easypases (id, pass) VALUES (558, 'golfer');
INSERT INTO public.easypases (id, pass) VALUES (559, 'summer');
INSERT INTO public.easypases (id, pass) VALUES (560, 'heather');
INSERT INTO public.easypases (id, pass) VALUES (561, 'hammer');
INSERT INTO public.easypases (id, pass) VALUES (562, 'yankees');
INSERT INTO public.easypases (id, pass) VALUES (563, 'joshua');
INSERT INTO public.easypases (id, pass) VALUES (564, 'maggie');
INSERT INTO public.easypases (id, pass) VALUES (565, 'biteme');
INSERT INTO public.easypases (id, pass) VALUES (566, 'enter');
INSERT INTO public.easypases (id, pass) VALUES (567, 'ashley');
INSERT INTO public.easypases (id, pass) VALUES (568, 'thunder');
INSERT INTO public.easypases (id, pass) VALUES (569, 'cowboy');
INSERT INTO public.easypases (id, pass) VALUES (570, 'silver');
INSERT INTO public.easypases (id, pass) VALUES (571, 'richard');
INSERT INTO public.easypases (id, pass) VALUES (572, 'fucker');
INSERT INTO public.easypases (id, pass) VALUES (573, 'orange');
INSERT INTO public.easypases (id, pass) VALUES (574, 'merlin');
INSERT INTO public.easypases (id, pass) VALUES (575, 'michelle');
INSERT INTO public.easypases (id, pass) VALUES (576, 'corvette');
INSERT INTO public.easypases (id, pass) VALUES (577, 'bigdog');
INSERT INTO public.easypases (id, pass) VALUES (578, 'cheese');
INSERT INTO public.easypases (id, pass) VALUES (579, 'matthew');
INSERT INTO public.easypases (id, pass) VALUES (580, '121212');
INSERT INTO public.easypases (id, pass) VALUES (581, 'patrick');
INSERT INTO public.easypases (id, pass) VALUES (582, 'martin');
INSERT INTO public.easypases (id, pass) VALUES (583, 'freedom');
INSERT INTO public.easypases (id, pass) VALUES (584, 'ginger');
INSERT INTO public.easypases (id, pass) VALUES (585, 'blowjob');
INSERT INTO public.easypases (id, pass) VALUES (586, 'nicole');
INSERT INTO public.easypases (id, pass) VALUES (587, 'sparky');
INSERT INTO public.easypases (id, pass) VALUES (588, 'yellow');
INSERT INTO public.easypases (id, pass) VALUES (589, 'camaro');
INSERT INTO public.easypases (id, pass) VALUES (590, 'secret');
INSERT INTO public.easypases (id, pass) VALUES (591, 'dick');
INSERT INTO public.easypases (id, pass) VALUES (592, 'falcon');
INSERT INTO public.easypases (id, pass) VALUES (593, 'taylor');
INSERT INTO public.easypases (id, pass) VALUES (594, '111111');
INSERT INTO public.easypases (id, pass) VALUES (595, '131313');
INSERT INTO public.easypases (id, pass) VALUES (596, '123123');
INSERT INTO public.easypases (id, pass) VALUES (597, 'bitch');
INSERT INTO public.easypases (id, pass) VALUES (598, 'hello');
INSERT INTO public.easypases (id, pass) VALUES (599, 'scooter');
INSERT INTO public.easypases (id, pass) VALUES (600, 'please');
INSERT INTO public.easypases (id, pass) VALUES (601, 'porsche');
INSERT INTO public.easypases (id, pass) VALUES (602, 'guitar');
INSERT INTO public.easypases (id, pass) VALUES (603, 'chelsea');
INSERT INTO public.easypases (id, pass) VALUES (604, 'black');
INSERT INTO public.easypases (id, pass) VALUES (605, 'diamond');
INSERT INTO public.easypases (id, pass) VALUES (606, 'nascar');
INSERT INTO public.easypases (id, pass) VALUES (607, 'jackson');
INSERT INTO public.easypases (id, pass) VALUES (608, 'cameron');
INSERT INTO public.easypases (id, pass) VALUES (609, '654321');
INSERT INTO public.easypases (id, pass) VALUES (610, 'computer');
INSERT INTO public.easypases (id, pass) VALUES (611, 'amanda');
INSERT INTO public.easypases (id, pass) VALUES (612, 'wizard');
INSERT INTO public.easypases (id, pass) VALUES (613, 'xxxxxxxx');
INSERT INTO public.easypases (id, pass) VALUES (614, 'money');
INSERT INTO public.easypases (id, pass) VALUES (615, 'phoenix');
INSERT INTO public.easypases (id, pass) VALUES (616, 'mickey');
INSERT INTO public.easypases (id, pass) VALUES (617, 'bailey');
INSERT INTO public.easypases (id, pass) VALUES (618, 'knight');
INSERT INTO public.easypases (id, pass) VALUES (619, 'iceman');
INSERT INTO public.easypases (id, pass) VALUES (620, 'tigers');
INSERT INTO public.easypases (id, pass) VALUES (621, 'purple');
INSERT INTO public.easypases (id, pass) VALUES (622, 'andrea');
INSERT INTO public.easypases (id, pass) VALUES (623, 'horny');
INSERT INTO public.easypases (id, pass) VALUES (624, 'dakota');
INSERT INTO public.easypases (id, pass) VALUES (625, 'aaaaaa');
INSERT INTO public.easypases (id, pass) VALUES (626, 'player');
INSERT INTO public.easypases (id, pass) VALUES (627, 'sunshine');
INSERT INTO public.easypases (id, pass) VALUES (628, 'morgan');
INSERT INTO public.easypases (id, pass) VALUES (629, 'starwars');
INSERT INTO public.easypases (id, pass) VALUES (630, 'boomer');
INSERT INTO public.easypases (id, pass) VALUES (631, 'cowboys');
INSERT INTO public.easypases (id, pass) VALUES (632, 'edward');
INSERT INTO public.easypases (id, pass) VALUES (633, 'charles');
INSERT INTO public.easypases (id, pass) VALUES (634, 'girls');
INSERT INTO public.easypases (id, pass) VALUES (635, 'booboo');
INSERT INTO public.easypases (id, pass) VALUES (636, 'coffee');
INSERT INTO public.easypases (id, pass) VALUES (637, 'xxxxxx');
INSERT INTO public.easypases (id, pass) VALUES (638, 'bulldog');
INSERT INTO public.easypases (id, pass) VALUES (639, 'ncc1701');
INSERT INTO public.easypases (id, pass) VALUES (640, 'rabbit');
INSERT INTO public.easypases (id, pass) VALUES (641, 'peanut');
INSERT INTO public.easypases (id, pass) VALUES (642, 'john');
INSERT INTO public.easypases (id, pass) VALUES (643, 'johnny');
INSERT INTO public.easypases (id, pass) VALUES (644, 'gandalf');
INSERT INTO public.easypases (id, pass) VALUES (645, 'spanky');
INSERT INTO public.easypases (id, pass) VALUES (646, 'winter');
INSERT INTO public.easypases (id, pass) VALUES (647, 'brandy');
INSERT INTO public.easypases (id, pass) VALUES (648, 'compaq');
INSERT INTO public.easypases (id, pass) VALUES (649, 'carlos');
INSERT INTO public.easypases (id, pass) VALUES (650, 'tennis');
INSERT INTO public.easypases (id, pass) VALUES (651, 'james');
INSERT INTO public.easypases (id, pass) VALUES (652, 'mike');
INSERT INTO public.easypases (id, pass) VALUES (653, 'brandon');
INSERT INTO public.easypases (id, pass) VALUES (654, 'fender');
INSERT INTO public.easypases (id, pass) VALUES (655, 'anthony');
INSERT INTO public.easypases (id, pass) VALUES (656, 'blowme');
INSERT INTO public.easypases (id, pass) VALUES (657, 'ferrari');
INSERT INTO public.easypases (id, pass) VALUES (658, 'cookie');
INSERT INTO public.easypases (id, pass) VALUES (659, 'chicken');
INSERT INTO public.easypases (id, pass) VALUES (660, 'maverick');
INSERT INTO public.easypases (id, pass) VALUES (661, 'chicago');
INSERT INTO public.easypases (id, pass) VALUES (662, 'joseph');
INSERT INTO public.easypases (id, pass) VALUES (663, 'diablo');
INSERT INTO public.easypases (id, pass) VALUES (664, 'sexsex');
INSERT INTO public.easypases (id, pass) VALUES (665, 'hardcore');
INSERT INTO public.easypases (id, pass) VALUES (666, '666666');
INSERT INTO public.easypases (id, pass) VALUES (667, 'willie');
INSERT INTO public.easypases (id, pass) VALUES (668, 'welcome');
INSERT INTO public.easypases (id, pass) VALUES (669, 'chris');
INSERT INTO public.easypases (id, pass) VALUES (670, 'panther');
INSERT INTO public.easypases (id, pass) VALUES (671, 'yamaha');
INSERT INTO public.easypases (id, pass) VALUES (672, 'justin');
INSERT INTO public.easypases (id, pass) VALUES (673, 'banana');
INSERT INTO public.easypases (id, pass) VALUES (674, 'driver');
INSERT INTO public.easypases (id, pass) VALUES (675, 'marine');
INSERT INTO public.easypases (id, pass) VALUES (676, 'angels');
INSERT INTO public.easypases (id, pass) VALUES (677, 'fishing');
INSERT INTO public.easypases (id, pass) VALUES (678, 'david');
INSERT INTO public.easypases (id, pass) VALUES (679, 'maddog');
INSERT INTO public.easypases (id, pass) VALUES (680, 'hooters');
INSERT INTO public.easypases (id, pass) VALUES (681, 'wilson');
INSERT INTO public.easypases (id, pass) VALUES (682, 'butthead');
INSERT INTO public.easypases (id, pass) VALUES (683, 'dennis');
INSERT INTO public.easypases (id, pass) VALUES (684, 'fucking');
INSERT INTO public.easypases (id, pass) VALUES (685, 'captain');
INSERT INTO public.easypases (id, pass) VALUES (686, 'bigdick');
INSERT INTO public.easypases (id, pass) VALUES (687, 'chester');
INSERT INTO public.easypases (id, pass) VALUES (688, 'smokey');
INSERT INTO public.easypases (id, pass) VALUES (689, 'xavier');
INSERT INTO public.easypases (id, pass) VALUES (690, 'steven');
INSERT INTO public.easypases (id, pass) VALUES (691, 'viking');
INSERT INTO public.easypases (id, pass) VALUES (692, 'snoopy');
INSERT INTO public.easypases (id, pass) VALUES (693, 'blue');
INSERT INTO public.easypases (id, pass) VALUES (694, 'eagles');
INSERT INTO public.easypases (id, pass) VALUES (695, 'winner');
INSERT INTO public.easypases (id, pass) VALUES (696, 'samantha');
INSERT INTO public.easypases (id, pass) VALUES (697, 'house');
INSERT INTO public.easypases (id, pass) VALUES (698, 'miller');
INSERT INTO public.easypases (id, pass) VALUES (699, 'flower');
INSERT INTO public.easypases (id, pass) VALUES (700, 'jack');
INSERT INTO public.easypases (id, pass) VALUES (701, 'firebird');
INSERT INTO public.easypases (id, pass) VALUES (702, 'butter');
INSERT INTO public.easypases (id, pass) VALUES (703, 'united');
INSERT INTO public.easypases (id, pass) VALUES (704, 'turtle');
INSERT INTO public.easypases (id, pass) VALUES (705, 'steelers');
INSERT INTO public.easypases (id, pass) VALUES (706, 'tiffany');
INSERT INTO public.easypases (id, pass) VALUES (707, 'zxcvbn');
INSERT INTO public.easypases (id, pass) VALUES (708, 'tomcat');
INSERT INTO public.easypases (id, pass) VALUES (709, 'golf');
INSERT INTO public.easypases (id, pass) VALUES (710, 'bond007');
INSERT INTO public.easypases (id, pass) VALUES (711, 'bear');
INSERT INTO public.easypases (id, pass) VALUES (712, 'tiger');
INSERT INTO public.easypases (id, pass) VALUES (713, 'doctor');
INSERT INTO public.easypases (id, pass) VALUES (714, 'gateway');
INSERT INTO public.easypases (id, pass) VALUES (715, 'gators');
INSERT INTO public.easypases (id, pass) VALUES (716, 'angel');
INSERT INTO public.easypases (id, pass) VALUES (717, 'junior');
INSERT INTO public.easypases (id, pass) VALUES (718, 'thx1138');
INSERT INTO public.easypases (id, pass) VALUES (719, 'porno');
INSERT INTO public.easypases (id, pass) VALUES (720, 'badboy');
INSERT INTO public.easypases (id, pass) VALUES (721, 'debbie');
INSERT INTO public.easypases (id, pass) VALUES (722, 'spider');
INSERT INTO public.easypases (id, pass) VALUES (723, 'melissa');
INSERT INTO public.easypases (id, pass) VALUES (724, 'booger');
INSERT INTO public.easypases (id, pass) VALUES (725, '1212');
INSERT INTO public.easypases (id, pass) VALUES (726, 'flyers');
INSERT INTO public.easypases (id, pass) VALUES (727, 'fish');
INSERT INTO public.easypases (id, pass) VALUES (728, 'porn');
INSERT INTO public.easypases (id, pass) VALUES (729, 'matrix');
INSERT INTO public.easypases (id, pass) VALUES (730, 'teens');
INSERT INTO public.easypases (id, pass) VALUES (731, 'scooby');
INSERT INTO public.easypases (id, pass) VALUES (732, 'jason');
INSERT INTO public.easypases (id, pass) VALUES (733, 'walter');
INSERT INTO public.easypases (id, pass) VALUES (734, 'cumshot');
INSERT INTO public.easypases (id, pass) VALUES (735, 'boston');
INSERT INTO public.easypases (id, pass) VALUES (736, 'braves');
INSERT INTO public.easypases (id, pass) VALUES (737, 'yankee');
INSERT INTO public.easypases (id, pass) VALUES (738, 'lover');
INSERT INTO public.easypases (id, pass) VALUES (739, 'barney');
INSERT INTO public.easypases (id, pass) VALUES (740, 'victor');
INSERT INTO public.easypases (id, pass) VALUES (741, 'tucker');
INSERT INTO public.easypases (id, pass) VALUES (742, 'princess');
INSERT INTO public.easypases (id, pass) VALUES (743, 'mercedes');
INSERT INTO public.easypases (id, pass) VALUES (744, '5150');
INSERT INTO public.easypases (id, pass) VALUES (745, 'doggie');
INSERT INTO public.easypases (id, pass) VALUES (746, 'zzzzzz');
INSERT INTO public.easypases (id, pass) VALUES (747, 'gunner');
INSERT INTO public.easypases (id, pass) VALUES (748, 'horney');
INSERT INTO public.easypases (id, pass) VALUES (749, 'bubba');
INSERT INTO public.easypases (id, pass) VALUES (750, '2112');
INSERT INTO public.easypases (id, pass) VALUES (751, 'fred');
INSERT INTO public.easypases (id, pass) VALUES (752, 'johnson');
INSERT INTO public.easypases (id, pass) VALUES (753, 'xxxxx');
INSERT INTO public.easypases (id, pass) VALUES (754, 'tits');
INSERT INTO public.easypases (id, pass) VALUES (755, 'member');
INSERT INTO public.easypases (id, pass) VALUES (756, 'boobs');
INSERT INTO public.easypases (id, pass) VALUES (757, 'donald');
INSERT INTO public.easypases (id, pass) VALUES (758, 'bigdaddy');
INSERT INTO public.easypases (id, pass) VALUES (759, 'bronco');
INSERT INTO public.easypases (id, pass) VALUES (760, 'penis');
INSERT INTO public.easypases (id, pass) VALUES (761, 'voyager');
INSERT INTO public.easypases (id, pass) VALUES (762, 'rangers');
INSERT INTO public.easypases (id, pass) VALUES (763, 'birdie');
INSERT INTO public.easypases (id, pass) VALUES (764, 'trouble');
INSERT INTO public.easypases (id, pass) VALUES (765, 'white');
INSERT INTO public.easypases (id, pass) VALUES (766, 'topgun');
INSERT INTO public.easypases (id, pass) VALUES (767, 'bigtits');
INSERT INTO public.easypases (id, pass) VALUES (768, 'bitches');
INSERT INTO public.easypases (id, pass) VALUES (769, 'green');
INSERT INTO public.easypases (id, pass) VALUES (770, 'super');
INSERT INTO public.easypases (id, pass) VALUES (771, 'qazwsx');
INSERT INTO public.easypases (id, pass) VALUES (772, 'magic');
INSERT INTO public.easypases (id, pass) VALUES (773, 'lakers');
INSERT INTO public.easypases (id, pass) VALUES (774, 'rachel');
INSERT INTO public.easypases (id, pass) VALUES (775, 'slayer');
INSERT INTO public.easypases (id, pass) VALUES (776, 'scott');
INSERT INTO public.easypases (id, pass) VALUES (777, '2222');
INSERT INTO public.easypases (id, pass) VALUES (778, 'asdf');
INSERT INTO public.easypases (id, pass) VALUES (779, 'video');
INSERT INTO public.easypases (id, pass) VALUES (780, 'london');
INSERT INTO public.easypases (id, pass) VALUES (781, '7777');
INSERT INTO public.easypases (id, pass) VALUES (782, 'marlboro');
INSERT INTO public.easypases (id, pass) VALUES (783, 'srinivas');
INSERT INTO public.easypases (id, pass) VALUES (784, 'internet');
INSERT INTO public.easypases (id, pass) VALUES (785, 'action');
INSERT INTO public.easypases (id, pass) VALUES (786, 'carter');
INSERT INTO public.easypases (id, pass) VALUES (787, 'jasper');
INSERT INTO public.easypases (id, pass) VALUES (788, 'monster');
INSERT INTO public.easypases (id, pass) VALUES (789, 'teresa');
INSERT INTO public.easypases (id, pass) VALUES (790, 'jeremy');
INSERT INTO public.easypases (id, pass) VALUES (791, '11111111');
INSERT INTO public.easypases (id, pass) VALUES (792, 'bill');
INSERT INTO public.easypases (id, pass) VALUES (793, 'crystal');
INSERT INTO public.easypases (id, pass) VALUES (794, 'peter');
INSERT INTO public.easypases (id, pass) VALUES (795, 'pussies');
INSERT INTO public.easypases (id, pass) VALUES (796, 'cock');
INSERT INTO public.easypases (id, pass) VALUES (797, 'beer');
INSERT INTO public.easypases (id, pass) VALUES (798, 'rocket');
INSERT INTO public.easypases (id, pass) VALUES (799, 'theman');
INSERT INTO public.easypases (id, pass) VALUES (800, 'oliver');
INSERT INTO public.easypases (id, pass) VALUES (801, 'prince');
INSERT INTO public.easypases (id, pass) VALUES (802, 'beach');
INSERT INTO public.easypases (id, pass) VALUES (803, 'amateur');
INSERT INTO public.easypases (id, pass) VALUES (804, '7777777');
INSERT INTO public.easypases (id, pass) VALUES (805, 'muffin');
INSERT INTO public.easypases (id, pass) VALUES (806, 'redsox');
INSERT INTO public.easypases (id, pass) VALUES (807, 'star');
INSERT INTO public.easypases (id, pass) VALUES (808, 'testing');
INSERT INTO public.easypases (id, pass) VALUES (809, 'shannon');
INSERT INTO public.easypases (id, pass) VALUES (810, 'murphy');
INSERT INTO public.easypases (id, pass) VALUES (811, 'frank');
INSERT INTO public.easypases (id, pass) VALUES (812, 'hannah');
INSERT INTO public.easypases (id, pass) VALUES (813, 'dave');
INSERT INTO public.easypases (id, pass) VALUES (814, 'eagle1');
INSERT INTO public.easypases (id, pass) VALUES (815, '11111');
INSERT INTO public.easypases (id, pass) VALUES (816, 'mother');
INSERT INTO public.easypases (id, pass) VALUES (817, 'nathan');
INSERT INTO public.easypases (id, pass) VALUES (818, 'raiders');
INSERT INTO public.easypases (id, pass) VALUES (819, 'steve');
INSERT INTO public.easypases (id, pass) VALUES (820, 'forever');
INSERT INTO public.easypases (id, pass) VALUES (821, 'angela');
INSERT INTO public.easypases (id, pass) VALUES (822, 'viper');
INSERT INTO public.easypases (id, pass) VALUES (823, 'ou812');
INSERT INTO public.easypases (id, pass) VALUES (824, 'jake');
INSERT INTO public.easypases (id, pass) VALUES (825, 'lovers');
INSERT INTO public.easypases (id, pass) VALUES (826, 'suckit');
INSERT INTO public.easypases (id, pass) VALUES (827, 'gregory');
INSERT INTO public.easypases (id, pass) VALUES (828, 'buddy');
INSERT INTO public.easypases (id, pass) VALUES (829, 'whatever');
INSERT INTO public.easypases (id, pass) VALUES (830, 'young');
INSERT INTO public.easypases (id, pass) VALUES (831, 'nicholas');
INSERT INTO public.easypases (id, pass) VALUES (832, 'lucky');
INSERT INTO public.easypases (id, pass) VALUES (833, 'helpme');
INSERT INTO public.easypases (id, pass) VALUES (834, 'jackie');
INSERT INTO public.easypases (id, pass) VALUES (835, 'monica');
INSERT INTO public.easypases (id, pass) VALUES (836, 'midnight');
INSERT INTO public.easypases (id, pass) VALUES (837, 'college');
INSERT INTO public.easypases (id, pass) VALUES (838, 'baby');
INSERT INTO public.easypases (id, pass) VALUES (839, 'cunt');
INSERT INTO public.easypases (id, pass) VALUES (840, 'brian');
INSERT INTO public.easypases (id, pass) VALUES (841, 'mark');
INSERT INTO public.easypases (id, pass) VALUES (842, 'startrek');
INSERT INTO public.easypases (id, pass) VALUES (843, 'sierra');
INSERT INTO public.easypases (id, pass) VALUES (844, 'leather');
INSERT INTO public.easypases (id, pass) VALUES (845, '232323');
INSERT INTO public.easypases (id, pass) VALUES (846, '4444');
INSERT INTO public.easypases (id, pass) VALUES (847, 'beavis');
INSERT INTO public.easypases (id, pass) VALUES (848, 'bigcock');
INSERT INTO public.easypases (id, pass) VALUES (849, 'happy');
INSERT INTO public.easypases (id, pass) VALUES (850, 'sophie');
INSERT INTO public.easypases (id, pass) VALUES (851, 'ladies');
INSERT INTO public.easypases (id, pass) VALUES (852, 'naughty');
INSERT INTO public.easypases (id, pass) VALUES (853, 'giants');
INSERT INTO public.easypases (id, pass) VALUES (854, 'booty');
INSERT INTO public.easypases (id, pass) VALUES (855, 'blonde');
INSERT INTO public.easypases (id, pass) VALUES (856, 'fucked');
INSERT INTO public.easypases (id, pass) VALUES (857, 'golden');
INSERT INTO public.easypases (id, pass) VALUES (858, '0');
INSERT INTO public.easypases (id, pass) VALUES (859, 'fire');
INSERT INTO public.easypases (id, pass) VALUES (860, 'sandra');
INSERT INTO public.easypases (id, pass) VALUES (861, 'pookie');
INSERT INTO public.easypases (id, pass) VALUES (862, 'packers');
INSERT INTO public.easypases (id, pass) VALUES (863, 'einstein');
INSERT INTO public.easypases (id, pass) VALUES (864, 'dolphins');
INSERT INTO public.easypases (id, pass) VALUES (865, 'chevy');
INSERT INTO public.easypases (id, pass) VALUES (866, 'winston');
INSERT INTO public.easypases (id, pass) VALUES (867, 'warrior');
INSERT INTO public.easypases (id, pass) VALUES (868, 'sammy');
INSERT INTO public.easypases (id, pass) VALUES (869, 'slut');
INSERT INTO public.easypases (id, pass) VALUES (870, '8675309');
INSERT INTO public.easypases (id, pass) VALUES (871, 'zxcvbnm');
INSERT INTO public.easypases (id, pass) VALUES (872, 'nipples');
INSERT INTO public.easypases (id, pass) VALUES (873, 'power');
INSERT INTO public.easypases (id, pass) VALUES (874, 'victoria');
INSERT INTO public.easypases (id, pass) VALUES (875, 'asdfgh');
INSERT INTO public.easypases (id, pass) VALUES (876, 'vagina');
INSERT INTO public.easypases (id, pass) VALUES (877, 'toyota');
INSERT INTO public.easypases (id, pass) VALUES (878, 'travis');
INSERT INTO public.easypases (id, pass) VALUES (879, 'hotdog');
INSERT INTO public.easypases (id, pass) VALUES (880, 'paris');
INSERT INTO public.easypases (id, pass) VALUES (881, 'rock');
INSERT INTO public.easypases (id, pass) VALUES (882, 'xxxx');
INSERT INTO public.easypases (id, pass) VALUES (883, 'extreme');
INSERT INTO public.easypases (id, pass) VALUES (884, 'redskins');
INSERT INTO public.easypases (id, pass) VALUES (885, 'erotic');
INSERT INTO public.easypases (id, pass) VALUES (886, 'dirty');
INSERT INTO public.easypases (id, pass) VALUES (887, 'ford');
INSERT INTO public.easypases (id, pass) VALUES (888, 'freddy');
INSERT INTO public.easypases (id, pass) VALUES (889, 'arsenal');
INSERT INTO public.easypases (id, pass) VALUES (890, 'access14');
INSERT INTO public.easypases (id, pass) VALUES (891, 'wolf');
INSERT INTO public.easypases (id, pass) VALUES (892, 'nipple');
INSERT INTO public.easypases (id, pass) VALUES (893, 'iloveyou');
INSERT INTO public.easypases (id, pass) VALUES (894, 'alex');
INSERT INTO public.easypases (id, pass) VALUES (895, 'florida');
INSERT INTO public.easypases (id, pass) VALUES (896, 'eric');
INSERT INTO public.easypases (id, pass) VALUES (897, 'legend');
INSERT INTO public.easypases (id, pass) VALUES (898, 'movie');
INSERT INTO public.easypases (id, pass) VALUES (899, 'success');
INSERT INTO public.easypases (id, pass) VALUES (900, 'rosebud');
INSERT INTO public.easypases (id, pass) VALUES (901, 'jaguar');
INSERT INTO public.easypases (id, pass) VALUES (902, 'great');
INSERT INTO public.easypases (id, pass) VALUES (903, 'cool');
INSERT INTO public.easypases (id, pass) VALUES (904, 'cooper');
INSERT INTO public.easypases (id, pass) VALUES (905, '1313');
INSERT INTO public.easypases (id, pass) VALUES (906, 'scorpio');
INSERT INTO public.easypases (id, pass) VALUES (907, 'mountain');
INSERT INTO public.easypases (id, pass) VALUES (908, 'madison');
INSERT INTO public.easypases (id, pass) VALUES (909, '987654');
INSERT INTO public.easypases (id, pass) VALUES (910, 'brazil');
INSERT INTO public.easypases (id, pass) VALUES (911, 'lauren');
INSERT INTO public.easypases (id, pass) VALUES (912, 'japan');
INSERT INTO public.easypases (id, pass) VALUES (913, 'naked');
INSERT INTO public.easypases (id, pass) VALUES (914, 'squirt');
INSERT INTO public.easypases (id, pass) VALUES (915, 'stars');
INSERT INTO public.easypases (id, pass) VALUES (916, 'apple');
INSERT INTO public.easypases (id, pass) VALUES (917, 'alexis');
INSERT INTO public.easypases (id, pass) VALUES (918, 'aaaa');
INSERT INTO public.easypases (id, pass) VALUES (919, 'bonnie');
INSERT INTO public.easypases (id, pass) VALUES (920, 'peaches');
INSERT INTO public.easypases (id, pass) VALUES (921, 'jasmine');
INSERT INTO public.easypases (id, pass) VALUES (922, 'kevin');
INSERT INTO public.easypases (id, pass) VALUES (923, 'matt');
INSERT INTO public.easypases (id, pass) VALUES (924, 'qwertyui');
INSERT INTO public.easypases (id, pass) VALUES (925, 'danielle');
INSERT INTO public.easypases (id, pass) VALUES (926, 'beaver');
INSERT INTO public.easypases (id, pass) VALUES (927, '4321');
INSERT INTO public.easypases (id, pass) VALUES (928, '4128');
INSERT INTO public.easypases (id, pass) VALUES (929, 'runner');
INSERT INTO public.easypases (id, pass) VALUES (930, 'swimming');
INSERT INTO public.easypases (id, pass) VALUES (931, 'dolphin');
INSERT INTO public.easypases (id, pass) VALUES (932, 'gordon');
INSERT INTO public.easypases (id, pass) VALUES (933, 'casper');
INSERT INTO public.easypases (id, pass) VALUES (934, 'stupid');
INSERT INTO public.easypases (id, pass) VALUES (935, 'shit');
INSERT INTO public.easypases (id, pass) VALUES (936, 'saturn');
INSERT INTO public.easypases (id, pass) VALUES (937, 'gemini');
INSERT INTO public.easypases (id, pass) VALUES (938, 'apples');
INSERT INTO public.easypases (id, pass) VALUES (939, 'august');
INSERT INTO public.easypases (id, pass) VALUES (940, '3333');
INSERT INTO public.easypases (id, pass) VALUES (941, 'canada');
INSERT INTO public.easypases (id, pass) VALUES (942, 'blazer');
INSERT INTO public.easypases (id, pass) VALUES (943, 'cumming');
INSERT INTO public.easypases (id, pass) VALUES (944, 'hunting');
INSERT INTO public.easypases (id, pass) VALUES (945, 'kitty');
INSERT INTO public.easypases (id, pass) VALUES (946, 'rainbow');
INSERT INTO public.easypases (id, pass) VALUES (947, '112233');
INSERT INTO public.easypases (id, pass) VALUES (948, 'arthur');
INSERT INTO public.easypases (id, pass) VALUES (949, 'cream');
INSERT INTO public.easypases (id, pass) VALUES (950, 'calvin');
INSERT INTO public.easypases (id, pass) VALUES (951, 'shaved');
INSERT INTO public.easypases (id, pass) VALUES (952, 'surfer');
INSERT INTO public.easypases (id, pass) VALUES (953, 'samson');
INSERT INTO public.easypases (id, pass) VALUES (954, 'kelly');
INSERT INTO public.easypases (id, pass) VALUES (955, 'paul');
INSERT INTO public.easypases (id, pass) VALUES (956, 'mine');
INSERT INTO public.easypases (id, pass) VALUES (957, 'king');
INSERT INTO public.easypases (id, pass) VALUES (958, 'racing');
INSERT INTO public.easypases (id, pass) VALUES (959, '5555');
INSERT INTO public.easypases (id, pass) VALUES (960, 'eagle');
INSERT INTO public.easypases (id, pass) VALUES (961, 'hentai');
INSERT INTO public.easypases (id, pass) VALUES (962, 'newyork');
INSERT INTO public.easypases (id, pass) VALUES (963, 'little');
INSERT INTO public.easypases (id, pass) VALUES (964, 'redwings');
INSERT INTO public.easypases (id, pass) VALUES (965, 'smith');
INSERT INTO public.easypases (id, pass) VALUES (966, 'sticky');
INSERT INTO public.easypases (id, pass) VALUES (967, 'cocacola');
INSERT INTO public.easypases (id, pass) VALUES (968, 'animal');
INSERT INTO public.easypases (id, pass) VALUES (969, 'broncos');
INSERT INTO public.easypases (id, pass) VALUES (970, 'private');
INSERT INTO public.easypases (id, pass) VALUES (971, 'skippy');
INSERT INTO public.easypases (id, pass) VALUES (972, 'marvin');
INSERT INTO public.easypases (id, pass) VALUES (973, 'blondes');
INSERT INTO public.easypases (id, pass) VALUES (974, 'enjoy');
INSERT INTO public.easypases (id, pass) VALUES (975, 'girl');
INSERT INTO public.easypases (id, pass) VALUES (976, 'apollo');
INSERT INTO public.easypases (id, pass) VALUES (977, 'parker');
INSERT INTO public.easypases (id, pass) VALUES (978, 'qwert');
INSERT INTO public.easypases (id, pass) VALUES (979, 'time');
INSERT INTO public.easypases (id, pass) VALUES (980, 'sydney');
INSERT INTO public.easypases (id, pass) VALUES (981, 'women');
INSERT INTO public.easypases (id, pass) VALUES (982, 'voodoo');
INSERT INTO public.easypases (id, pass) VALUES (983, 'magnum');
INSERT INTO public.easypases (id, pass) VALUES (984, 'juice');
INSERT INTO public.easypases (id, pass) VALUES (985, 'abgrtyu');
INSERT INTO public.easypases (id, pass) VALUES (986, '777777');
INSERT INTO public.easypases (id, pass) VALUES (987, 'dreams');
INSERT INTO public.easypases (id, pass) VALUES (988, 'maxwell');
INSERT INTO public.easypases (id, pass) VALUES (989, 'music');
INSERT INTO public.easypases (id, pass) VALUES (990, 'rush2112');
INSERT INTO public.easypases (id, pass) VALUES (991, 'russia');
INSERT INTO public.easypases (id, pass) VALUES (992, 'scorpion');
INSERT INTO public.easypases (id, pass) VALUES (993, 'rebecca');
INSERT INTO public.easypases (id, pass) VALUES (994, 'tester');
INSERT INTO public.easypases (id, pass) VALUES (995, 'mistress');
INSERT INTO public.easypases (id, pass) VALUES (996, 'phantom');
INSERT INTO public.easypases (id, pass) VALUES (997, 'billy');
INSERT INTO public.easypases (id, pass) VALUES (998, '6666');
INSERT INTO public.easypases (id, pass) VALUES (999, 'albert');
INSERT INTO public.easypases (id, pass) VALUES (1000, '123456');
INSERT INTO public.easypases (id, pass) VALUES (1001, 'lol123');
INSERT INTO public.easypases (id, pass) VALUES (1002, '123456789');
INSERT INTO public.easypases (id, pass) VALUES (1003, '12345');
INSERT INTO public.easypases (id, pass) VALUES (1004, 'test123');
INSERT INTO public.easypases (id, pass) VALUES (1005, 'password123');
INSERT INTO public.easypases (id, pass) VALUES (1006, '123123');
INSERT INTO public.easypases (id, pass) VALUES (1007, 'password1');
INSERT INTO public.easypases (id, pass) VALUES (1008, 'abc123');
INSERT INTO public.easypases (id, pass) VALUES (1009, 'qwerty');
INSERT INTO public.easypases (id, pass) VALUES (1010, 'exedra345');
INSERT INTO public.easypases (id, pass) VALUES (1011, 'fuckyou');
INSERT INTO public.easypases (id, pass) VALUES (1012, '123123123');
INSERT INTO public.easypases (id, pass) VALUES (1013, 'azerty');
INSERT INTO public.easypases (id, pass) VALUES (1014, '123qwe');
INSERT INTO public.easypases (id, pass) VALUES (1015, 'hallo123');
INSERT INTO public.easypases (id, pass) VALUES (1016, 'lizardsquad');
INSERT INTO public.easypases (id, pass) VALUES (1017, 'qwerty123');
INSERT INTO public.easypases (id, pass) VALUES (1018, 'qwertyuiop');
INSERT INTO public.easypases (id, pass) VALUES (1019, 'g00dPa$$w0rD');
INSERT INTO public.easypases (id, pass) VALUES (1020, 'nigger123');
INSERT INTO public.easypases (id, pass) VALUES (1021, 'lollol');
INSERT INTO public.easypases (id, pass) VALUES (1022, 'Password123');
INSERT INTO public.easypases (id, pass) VALUES (1023, '123qweasd');
INSERT INTO public.easypases (id, pass) VALUES (1024, 'testtest');
INSERT INTO public.easypases (id, pass) VALUES (1025, 'nigger');
INSERT INTO public.easypases (id, pass) VALUES (1026, 'lizard');
INSERT INTO public.easypases (id, pass) VALUES (1027, '12345678');
INSERT INTO public.easypases (id, pass) VALUES (1028, 'azerty123');
INSERT INTO public.easypases (id, pass) VALUES (1029, 'yoloswag');
INSERT INTO public.easypases (id, pass) VALUES (1030, '1234567');
INSERT INTO public.easypases (id, pass) VALUES (1031, 'lol12345');
INSERT INTO public.easypases (id, pass) VALUES (1032, 'aaaaaa');
INSERT INTO public.easypases (id, pass) VALUES (1033, 'haha123');
INSERT INTO public.easypases (id, pass) VALUES (1034, '1234567890');
INSERT INTO public.easypases (id, pass) VALUES (1035, 'Password1');
INSERT INTO public.easypases (id, pass) VALUES (1036, 'swag123');
INSERT INTO public.easypases (id, pass) VALUES (1037, 'lol123321');
INSERT INTO public.easypases (id, pass) VALUES (1038, 'penis');
INSERT INTO public.easypases (id, pass) VALUES (1039, 'qwe123');
INSERT INTO public.easypases (id, pass) VALUES (1040, 'herpderp123');
INSERT INTO public.easypases (id, pass) VALUES (1041, '123321');
INSERT INTO public.easypases (id, pass) VALUES (1042, 'admin');
INSERT INTO public.easypases (id, pass) VALUES (1043, 'abcd1234');
INSERT INTO public.easypases (id, pass) VALUES (1044, 'asdasdasd');
INSERT INTO public.easypases (id, pass) VALUES (1045, '1qaz2wsx');
INSERT INTO public.easypases (id, pass) VALUES (1046, 'nascar48');
INSERT INTO public.easypases (id, pass) VALUES (1047, 'asdf1234');
INSERT INTO public.easypases (id, pass) VALUES (1048, 'poop123');
INSERT INTO public.easypases (id, pass) VALUES (1049, 'pokemon');
INSERT INTO public.easypases (id, pass) VALUES (1050, 'azertyuiop');
INSERT INTO public.easypases (id, pass) VALUES (1051, 'hello');
INSERT INTO public.easypases (id, pass) VALUES (1052, 'lol1234');
INSERT INTO public.easypases (id, pass) VALUES (1053, 'asdasd');
INSERT INTO public.easypases (id, pass) VALUES (1054, '1q2w3e4r');
INSERT INTO public.easypases (id, pass) VALUES (1055, 'acUn3t1x');
INSERT INTO public.easypases (id, pass) VALUES (1056, 'abcdefg');
INSERT INTO public.easypases (id, pass) VALUES (1057, 'lol123456');
INSERT INTO public.easypases (id, pass) VALUES (1058, 'qweqweqwe');
INSERT INTO public.easypases (id, pass) VALUES (1059, 'swagswag');
INSERT INTO public.easypases (id, pass) VALUES (1060, '1q2w3e');
INSERT INTO public.easypases (id, pass) VALUES (1061, 'fuckyou123');
INSERT INTO public.easypases (id, pass) VALUES (1062, 'qwert123');
INSERT INTO public.easypases (id, pass) VALUES (1063, 'fuckoff');
INSERT INTO public.easypases (id, pass) VALUES (1064, 'qwerty1');
INSERT INTO public.easypases (id, pass) VALUES (1065, '1234qwer');
INSERT INTO public.easypases (id, pass) VALUES (1066, 'niggers');
INSERT INTO public.easypases (id, pass) VALUES (1067, 'fucku');
INSERT INTO public.easypases (id, pass) VALUES (1068, 'test1234');
INSERT INTO public.easypases (id, pass) VALUES (1069, 'pass123');
INSERT INTO public.easypases (id, pass) VALUES (1070, 'hahaha');
INSERT INTO public.easypases (id, pass) VALUES (1071, 'blablabla');
INSERT INTO public.easypases (id, pass) VALUES (1072, '123qwe123');
INSERT INTO public.easypases (id, pass) VALUES (1073, 'lizard123');
INSERT INTO public.easypases (id, pass) VALUES (1074, '1qazxsw2');
INSERT INTO public.easypases (id, pass) VALUES (1075, 'lololol');
INSERT INTO public.easypases (id, pass) VALUES (1076, 'Lizard');
INSERT INTO public.easypases (id, pass) VALUES (1077, 'boobs');
INSERT INTO public.easypases (id, pass) VALUES (1078, 'lizardstresser');
INSERT INTO public.easypases (id, pass) VALUES (1079, 'liverpool123');
INSERT INTO public.easypases (id, pass) VALUES (1080, 'faggot');
INSERT INTO public.easypases (id, pass) VALUES (1081, '1q2w3e4r5t');
INSERT INTO public.easypases (id, pass) VALUES (1082, 'ed.fisica');
INSERT INTO public.easypases (id, pass) VALUES (1083, '654321');
INSERT INTO public.easypases (id, pass) VALUES (1084, 'asdfghjkl');
INSERT INTO public.easypases (id, pass) VALUES (1085, 'football');
INSERT INTO public.easypases (id, pass) VALUES (1086, '12341234');
INSERT INTO public.easypases (id, pass) VALUES (1087, 'nick1234');
INSERT INTO public.easypases (id, pass) VALUES (1088, 'lolol');
INSERT INTO public.easypases (id, pass) VALUES (1089, 'pussy');
INSERT INTO public.easypases (id, pass) VALUES (1090, 'aaabbbccc');
INSERT INTO public.easypases (id, pass) VALUES (1091, 'hola123');
INSERT INTO public.easypases (id, pass) VALUES (1092, 'starwars');
INSERT INTO public.easypases (id, pass) VALUES (1093, 'emreadim36');
INSERT INTO public.easypases (id, pass) VALUES (1094, 'kanker');
INSERT INTO public.easypases (id, pass) VALUES (1095, 'lollol123');
INSERT INTO public.easypases (id, pass) VALUES (1096, 'nigger12');
INSERT INTO public.easypases (id, pass) VALUES (1097, 'qazwsxedc');
INSERT INTO public.easypases (id, pass) VALUES (1098, 'p4ssword');
INSERT INTO public.easypases (id, pass) VALUES (1099, 'Penis');
INSERT INTO public.easypases (id, pass) VALUES (1100, 'hello123');
INSERT INTO public.easypases (id, pass) VALUES (1101, 'letmein');
INSERT INTO public.easypases (id, pass) VALUES (1102, 'pokemon123');
INSERT INTO public.easypases (id, pass) VALUES (1103, 'killer');
INSERT INTO public.easypases (id, pass) VALUES (1104, 'zxcvbnm');
INSERT INTO public.easypases (id, pass) VALUES (1105, 'bob123');
INSERT INTO public.easypases (id, pass) VALUES (1106, 'niggers1');
INSERT INTO public.easypases (id, pass) VALUES (1107, 'aaaaa');
INSERT INTO public.easypases (id, pass) VALUES (1108, 'sssss');
INSERT INTO public.easypases (id, pass) VALUES (1109, 'abcdabcd');
INSERT INTO public.easypases (id, pass) VALUES (1110, 'senha123');
INSERT INTO public.easypases (id, pass) VALUES (1111, '123456a');
INSERT INTO public.easypases (id, pass) VALUES (1112, 'insane');
INSERT INTO public.easypases (id, pass) VALUES (1113, '023325');
INSERT INTO public.easypases (id, pass) VALUES (1114, 'passw0rd');
INSERT INTO public.easypases (id, pass) VALUES (1115, 'qwertz');
INSERT INTO public.easypases (id, pass) VALUES (1116, 'lolilol');
INSERT INTO public.easypases (id, pass) VALUES (1117, 'asdfasdf');
INSERT INTO public.easypases (id, pass) VALUES (1118, '12qwaszx');
INSERT INTO public.easypases (id, pass) VALUES (1119, '121212');
INSERT INTO public.easypases (id, pass) VALUES (1120, 'ILoveRachel');
INSERT INTO public.easypases (id, pass) VALUES (1121, 'hackme');
INSERT INTO public.easypases (id, pass) VALUES (1122, 'roflmao');
INSERT INTO public.easypases (id, pass) VALUES (1123, 'suarez123');
INSERT INTO public.easypases (id, pass) VALUES (1124, 'agudjyttwe');
INSERT INTO public.easypases (id, pass) VALUES (1125, 'lol12');
INSERT INTO public.easypases (id, pass) VALUES (1126, 'derp021');
INSERT INTO public.easypases (id, pass) VALUES (1127, 'gohan1023');
INSERT INTO public.easypases (id, pass) VALUES (1128, 'hacker55');
INSERT INTO public.easypases (id, pass) VALUES (1129, 'hunter12');
INSERT INTO public.easypases (id, pass) VALUES (1130, 'Gangstar1');
INSERT INTO public.easypases (id, pass) VALUES (1131, 'p00p00123');
INSERT INTO public.easypases (id, pass) VALUES (1132, '123123uu');
INSERT INTO public.easypases (id, pass) VALUES (1133, 'iifail');
INSERT INTO public.easypases (id, pass) VALUES (1134, 'dragon123');
INSERT INTO public.easypases (id, pass) VALUES (1135, 'na53xa1!');
INSERT INTO public.easypases (id, pass) VALUES (1136, '1q2q3q4q');
INSERT INTO public.easypases (id, pass) VALUES (1137, 'a1234567');
INSERT INTO public.easypases (id, pass) VALUES (1138, 'jesse123');
INSERT INTO public.easypases (id, pass) VALUES (1139, 'freedom');
INSERT INTO public.easypases (id, pass) VALUES (1140, 'nopass');
INSERT INTO public.easypases (id, pass) VALUES (1141, 'CATS123');
INSERT INTO public.easypases (id, pass) VALUES (1142, 'any6gkbi');
INSERT INTO public.easypases (id, pass) VALUES (1143, 'peanutbutter');
INSERT INTO public.easypases (id, pass) VALUES (1144, '5428793Dff');
INSERT INTO public.easypases (id, pass) VALUES (1145, 'warrock123');
INSERT INTO public.easypases (id, pass) VALUES (1146, 'yoloswag1');
INSERT INTO public.easypases (id, pass) VALUES (1147, 'aqwxszedc');
INSERT INTO public.easypases (id, pass) VALUES (1148, 'fuckmecunt');
INSERT INTO public.easypases (id, pass) VALUES (1149, 'boss0815');
INSERT INTO public.easypases (id, pass) VALUES (1150, 'luis97');
INSERT INTO public.easypases (id, pass) VALUES (1151, 'ebola');
INSERT INTO public.easypases (id, pass) VALUES (1152, 'qweqwe');
INSERT INTO public.easypases (id, pass) VALUES (1153, 'triplets');
INSERT INTO public.easypases (id, pass) VALUES (1154, '123123123p');
INSERT INTO public.easypases (id, pass) VALUES (1155, 'nfs123');
INSERT INTO public.easypases (id, pass) VALUES (1156, 'master123');
INSERT INTO public.easypases (id, pass) VALUES (1157, 'wile8&micrometer');
INSERT INTO public.easypases (id, pass) VALUES (1158, 'mikiez84');
INSERT INTO public.easypases (id, pass) VALUES (1159, 'blake123');
INSERT INTO public.easypases (id, pass) VALUES (1160, 'ruthere');
INSERT INTO public.easypases (id, pass) VALUES (1161, 'Squeak12345');
INSERT INTO public.easypases (id, pass) VALUES (1162, 'pedroia15');
INSERT INTO public.easypases (id, pass) VALUES (1163, 'chido@1');
INSERT INTO public.easypases (id, pass) VALUES (1164, 'poopoo');
INSERT INTO public.easypases (id, pass) VALUES (1165, '66da6698');
INSERT INTO public.easypases (id, pass) VALUES (1166, 'asdf123');
INSERT INTO public.easypases (id, pass) VALUES (1167, 'aap100');
INSERT INTO public.easypases (id, pass) VALUES (1168, 'lol123123');
INSERT INTO public.easypases (id, pass) VALUES (1169, 'a1b2c3d4');
INSERT INTO public.easypases (id, pass) VALUES (1170, 'dbx73ndg');
INSERT INTO public.easypases (id, pass) VALUES (1171, 'Fettsack1');
INSERT INTO public.easypases (id, pass) VALUES (1172, 'lol1231');
INSERT INTO public.easypases (id, pass) VALUES (1173, 'Garfield1');
INSERT INTO public.easypases (id, pass) VALUES (1174, 'fuckyou1');
INSERT INTO public.easypases (id, pass) VALUES (1175, 'jumper10');
INSERT INTO public.easypases (id, pass) VALUES (1176, 'Wildy123');
INSERT INTO public.easypases (id, pass) VALUES (1177, 'idontknow');
INSERT INTO public.easypases (id, pass) VALUES (1178, 'hello1234');
INSERT INTO public.easypases (id, pass) VALUES (1179, 'ddos5846985');
INSERT INTO public.easypases (id, pass) VALUES (1180, 'bruces22');
INSERT INTO public.easypases (id, pass) VALUES (1181, 'ilikebob');
INSERT INTO public.easypases (id, pass) VALUES (1182, 'xxmythpvpxx');
INSERT INTO public.easypases (id, pass) VALUES (1183, 'jish123456');
INSERT INTO public.easypases (id, pass) VALUES (1184, 'genesis01');
INSERT INTO public.easypases (id, pass) VALUES (1185, 'jemoeder1');
INSERT INTO public.easypases (id, pass) VALUES (1186, 'stormy78');
INSERT INTO public.easypases (id, pass) VALUES (1187, 'fuckme');
INSERT INTO public.easypases (id, pass) VALUES (1188, 'koekkoek1');
INSERT INTO public.easypases (id, pass) VALUES (1189, 'swaglord123');
INSERT INTO public.easypases (id, pass) VALUES (1190, 'aa12ftl');
INSERT INTO public.easypases (id, pass) VALUES (1191, 'monster');
INSERT INTO public.easypases (id, pass) VALUES (1192, 'exploit');
INSERT INTO public.easypases (id, pass) VALUES (1193, 'Jivedaddydave08');
INSERT INTO public.easypases (id, pass) VALUES (1194, 'sanjose408');
INSERT INTO public.easypases (id, pass) VALUES (1195, 'Noplans1');
INSERT INTO public.easypases (id, pass) VALUES (1196, 'lizardgay');
INSERT INTO public.easypases (id, pass) VALUES (1197, 'nhl1999');
INSERT INTO public.easypases (id, pass) VALUES (1198, 'Diesel01');
INSERT INTO public.easypases (id, pass) VALUES (1199, 'acer123');
INSERT INTO public.easypases (id, pass) VALUES (1200, 'pancakes123');
INSERT INTO public.easypases (id, pass) VALUES (1201, 'booter');
INSERT INTO public.easypases (id, pass) VALUES (1202, 'iseeyou');
INSERT INTO public.easypases (id, pass) VALUES (1203, 'bv4cj8b8');
INSERT INTO public.easypases (id, pass) VALUES (1204, 'fuckoffcunt');
INSERT INTO public.easypases (id, pass) VALUES (1205, 'fagboy');
INSERT INTO public.easypases (id, pass) VALUES (1206, 'pokemon1');
INSERT INTO public.easypases (id, pass) VALUES (1207, 'lucki8');
INSERT INTO public.easypases (id, pass) VALUES (1208, 'bbbbbb');
INSERT INTO public.easypases (id, pass) VALUES (1209, 'joshua12');
INSERT INTO public.easypases (id, pass) VALUES (1210, 'molly5678');
INSERT INTO public.easypases (id, pass) VALUES (1211, 'beat12');
INSERT INTO public.easypases (id, pass) VALUES (1212, 'jordan23');
INSERT INTO public.easypases (id, pass) VALUES (1213, 'L1272005q');
INSERT INTO public.easypases (id, pass) VALUES (1214, 'Tee313131');
INSERT INTO public.easypases (id, pass) VALUES (1215, 'coolman');
INSERT INTO public.easypases (id, pass) VALUES (1216, 'Bocaj0190813');
INSERT INTO public.easypases (id, pass) VALUES (1217, 'hometeam11');
INSERT INTO public.easypases (id, pass) VALUES (1218, 'hampster1');
INSERT INTO public.easypases (id, pass) VALUES (1219, 'lionio');
INSERT INTO public.easypases (id, pass) VALUES (1220, 'sasuke123');
INSERT INTO public.easypases (id, pass) VALUES (1221, 'msmith98');
INSERT INTO public.easypases (id, pass) VALUES (1222, 'Lol12345');
INSERT INTO public.easypases (id, pass) VALUES (1223, 'mp3Torrent');
INSERT INTO public.easypases (id, pass) VALUES (1224, 'sajenas12');
INSERT INTO public.easypases (id, pass) VALUES (1225, 'her0ziscool123');
INSERT INTO public.easypases (id, pass) VALUES (1226, '123454321');
INSERT INTO public.easypases (id, pass) VALUES (1227, '000000');
INSERT INTO public.easypases (id, pass) VALUES (1228, 'hhhhh');
INSERT INTO public.easypases (id, pass) VALUES (1229, '98078476Abc');
INSERT INTO public.easypases (id, pass) VALUES (1230, 'hunter2');
INSERT INTO public.easypases (id, pass) VALUES (1231, 'reynerie31');
INSERT INTO public.easypases (id, pass) VALUES (1232, '123abc');
INSERT INTO public.easypases (id, pass) VALUES (1233, 'benjamin123');
INSERT INTO public.easypases (id, pass) VALUES (1234, 'jamz234567');
INSERT INTO public.easypases (id, pass) VALUES (1235, 'defaultpass1108');
INSERT INTO public.easypases (id, pass) VALUES (1236, 'ciaociao');
INSERT INTO public.easypases (id, pass) VALUES (1237, 'Bella123');
INSERT INTO public.easypases (id, pass) VALUES (1238, '1234290A');
INSERT INTO public.easypases (id, pass) VALUES (1239, 'spiderman');
INSERT INTO public.easypases (id, pass) VALUES (1240, 'LOL12345');
INSERT INTO public.easypases (id, pass) VALUES (1241, 'shitbricks');
INSERT INTO public.easypases (id, pass) VALUES (1242, 'andrew123');
INSERT INTO public.easypases (id, pass) VALUES (1243, 'rooney');
INSERT INTO public.easypases (id, pass) VALUES (1244, 'moi123');
INSERT INTO public.easypases (id, pass) VALUES (1245, 'test1337');
INSERT INTO public.easypases (id, pass) VALUES (1246, '0920541064');
INSERT INTO public.easypases (id, pass) VALUES (1247, 'StruhtDesigns97');
INSERT INTO public.easypases (id, pass) VALUES (1248, '1234567a');
INSERT INTO public.easypases (id, pass) VALUES (1249, 'qwer1234');
INSERT INTO public.easypases (id, pass) VALUES (1250, 'porcodio');
INSERT INTO public.easypases (id, pass) VALUES (1251, 'wwerocks123');
INSERT INTO public.easypases (id, pass) VALUES (1252, 'vicecity');
INSERT INTO public.easypases (id, pass) VALUES (1253, 'peanut');
INSERT INTO public.easypases (id, pass) VALUES (1254, 'ulei4663');
INSERT INTO public.easypases (id, pass) VALUES (1255, 'boyzie98');
INSERT INTO public.easypases (id, pass) VALUES (1256, 'abc1234');
INSERT INTO public.easypases (id, pass) VALUES (1257, 'asdasd123');
INSERT INTO public.easypases (id, pass) VALUES (1258, 'AsiraK@1892');
INSERT INTO public.easypases (id, pass) VALUES (1259, '123lol123');
INSERT INTO public.easypases (id, pass) VALUES (1260, 'elnumero1');
INSERT INTO public.easypases (id, pass) VALUES (1261, 'tkmodz4u');
INSERT INTO public.easypases (id, pass) VALUES (1262, 'amsterdam1');
INSERT INTO public.easypases (id, pass) VALUES (1263, 'testing');
INSERT INTO public.easypases (id, pass) VALUES (1264, 'baseball17');
INSERT INTO public.easypases (id, pass) VALUES (1265, 'password1234');
INSERT INTO public.easypases (id, pass) VALUES (1266, 'test1');
INSERT INTO public.easypases (id, pass) VALUES (1267, 'hoeren');
INSERT INTO public.easypases (id, pass) VALUES (1268, 'fucker123');
INSERT INTO public.easypases (id, pass) VALUES (1269, 'michael');
INSERT INTO public.easypases (id, pass) VALUES (1270, 'squad');
INSERT INTO public.easypases (id, pass) VALUES (1271, 'peppizza');
INSERT INTO public.easypases (id, pass) VALUES (1272, 'lmfao');
INSERT INTO public.easypases (id, pass) VALUES (1273, 'eriksson1');
INSERT INTO public.easypases (id, pass) VALUES (1274, 'mark2001');
INSERT INTO public.easypases (id, pass) VALUES (1275, 'popopo');
INSERT INTO public.easypases (id, pass) VALUES (1276, 'teus123');
INSERT INTO public.easypases (id, pass) VALUES (1277, '123456789r');
INSERT INTO public.easypases (id, pass) VALUES (1278, 'koko07');
INSERT INTO public.easypases (id, pass) VALUES (1279, 'gage1432');
INSERT INTO public.easypases (id, pass) VALUES (1280, '111111');
INSERT INTO public.easypases (id, pass) VALUES (1281, 'winston');
INSERT INTO public.easypases (id, pass) VALUES (1282, 'blackpool1');
INSERT INTO public.easypases (id, pass) VALUES (1283, 'nathan');
INSERT INTO public.easypases (id, pass) VALUES (1284, '1985hyas');
INSERT INTO public.easypases (id, pass) VALUES (1285, 'youtube');
INSERT INTO public.easypases (id, pass) VALUES (1286, 'ABSxYz182');
INSERT INTO public.easypases (id, pass) VALUES (1287, 'robot2003');
INSERT INTO public.easypases (id, pass) VALUES (1288, 'remember');
INSERT INTO public.easypases (id, pass) VALUES (1289, 'green12');
INSERT INTO public.easypases (id, pass) VALUES (1290, 'Password1234');
INSERT INTO public.easypases (id, pass) VALUES (1291, 'azerty1234');
INSERT INTO public.easypases (id, pass) VALUES (1292, 'haha1234');
INSERT INTO public.easypases (id, pass) VALUES (1293, 'bellabella');
INSERT INTO public.easypases (id, pass) VALUES (1294, 'palla0');
INSERT INTO public.easypases (id, pass) VALUES (1295, 'Football5');
INSERT INTO public.easypases (id, pass) VALUES (1296, 'nicolas1999');
INSERT INTO public.easypases (id, pass) VALUES (1297, 'lmao123');
INSERT INTO public.easypases (id, pass) VALUES (1298, 'blah1234');
INSERT INTO public.easypases (id, pass) VALUES (1299, 'asdasd21');
INSERT INTO public.easypases (id, pass) VALUES (1300, '733026');
INSERT INTO public.easypases (id, pass) VALUES (1301, 'fuckoff123');
INSERT INTO public.easypases (id, pass) VALUES (1302, 'loldongs');
INSERT INTO public.easypases (id, pass) VALUES (1303, 'Jerk921@');
INSERT INTO public.easypases (id, pass) VALUES (1304, 'password12345');
INSERT INTO public.easypases (id, pass) VALUES (1305, 'sexy123');
INSERT INTO public.easypases (id, pass) VALUES (1306, 'asdasd11');
INSERT INTO public.easypases (id, pass) VALUES (1307, 'Yllzoni1');
INSERT INTO public.easypases (id, pass) VALUES (1308, 'alexander');
INSERT INTO public.easypases (id, pass) VALUES (1309, 'rofl123');
INSERT INTO public.easypases (id, pass) VALUES (1310, 'nanny123');
INSERT INTO public.easypases (id, pass) VALUES (1311, 'elochukwu');
INSERT INTO public.easypases (id, pass) VALUES (1312, 'localhost223');
INSERT INTO public.easypases (id, pass) VALUES (1313, 'Password69');
INSERT INTO public.easypases (id, pass) VALUES (1314, 'goon123');
INSERT INTO public.easypases (id, pass) VALUES (1315, 'mxmltl22');
INSERT INTO public.easypases (id, pass) VALUES (1316, '1qaz!QAZ');
INSERT INTO public.easypases (id, pass) VALUES (1317, 'kevin123');
INSERT INTO public.easypases (id, pass) VALUES (1318, 'Yoloswag');
INSERT INTO public.easypases (id, pass) VALUES (1319, 'qwerty11');
INSERT INTO public.easypases (id, pass) VALUES (1320, 'alex12');
INSERT INTO public.easypases (id, pass) VALUES (1321, 'baseball123');
INSERT INTO public.easypases (id, pass) VALUES (1322, 'bob12345');
INSERT INTO public.easypases (id, pass) VALUES (1323, 'Monsterman13');
INSERT INTO public.easypases (id, pass) VALUES (1324, 'skater2730');
INSERT INTO public.easypases (id, pass) VALUES (1325, 'bigboss');
INSERT INTO public.easypases (id, pass) VALUES (1326, 'nomnomnom123');
INSERT INTO public.easypases (id, pass) VALUES (1327, 'loldongs123');
INSERT INTO public.easypases (id, pass) VALUES (1328, 'Maxwell');
INSERT INTO public.easypases (id, pass) VALUES (1329, 'lollipop123321');
INSERT INTO public.easypases (id, pass) VALUES (1330, 'mohamed123');
INSERT INTO public.easypases (id, pass) VALUES (1331, 'daisuketest');
INSERT INTO public.easypases (id, pass) VALUES (1332, 'makana62');
INSERT INTO public.easypases (id, pass) VALUES (1333, 'azerty24');
INSERT INTO public.easypases (id, pass) VALUES (1334, 'john123');
INSERT INTO public.easypases (id, pass) VALUES (1335, '311311');
INSERT INTO public.easypases (id, pass) VALUES (1336, '258258');
INSERT INTO public.easypases (id, pass) VALUES (1337, 'kobe123');
INSERT INTO public.easypases (id, pass) VALUES (1338, 'tim2699');
INSERT INTO public.easypases (id, pass) VALUES (1339, 'socket77');
INSERT INTO public.easypases (id, pass) VALUES (1340, 'madeyer');
INSERT INTO public.easypases (id, pass) VALUES (1341, 'donkey');
INSERT INTO public.easypases (id, pass) VALUES (1342, 'test12345');
INSERT INTO public.easypases (id, pass) VALUES (1343, 'lizards');
INSERT INTO public.easypases (id, pass) VALUES (1344, 'uniden123');
INSERT INTO public.easypases (id, pass) VALUES (1345, 'turkey');
INSERT INTO public.easypases (id, pass) VALUES (1346, 'binds1234');
INSERT INTO public.easypases (id, pass) VALUES (1347, 'shingles23');
INSERT INTO public.easypases (id, pass) VALUES (1348, 'people1234');
INSERT INTO public.easypases (id, pass) VALUES (1349, 'rsiscalx6191');
INSERT INTO public.easypases (id, pass) VALUES (1350, 'something');
INSERT INTO public.easypases (id, pass) VALUES (1351, 'Rangers123');
INSERT INTO public.easypases (id, pass) VALUES (1352, 'hacker@13');
INSERT INTO public.easypases (id, pass) VALUES (1353, 'booter123');
INSERT INTO public.easypases (id, pass) VALUES (1354, 'hello1');
INSERT INTO public.easypases (id, pass) VALUES (1355, 'coinslash1');
INSERT INTO public.easypases (id, pass) VALUES (1356, 'flamethrower');
INSERT INTO public.easypases (id, pass) VALUES (1357, 'halo123456');
INSERT INTO public.easypases (id, pass) VALUES (1358, 'pomme123');
INSERT INTO public.easypases (id, pass) VALUES (1359, 'joshua');
INSERT INTO public.easypases (id, pass) VALUES (1360, '123454');
INSERT INTO public.easypases (id, pass) VALUES (1361, 'shjds@*&saksuy');
INSERT INTO public.easypases (id, pass) VALUES (1362, 'Ilikesoccer1');
INSERT INTO public.easypases (id, pass) VALUES (1363, 'soccer');
INSERT INTO public.easypases (id, pass) VALUES (1364, 'qwertyui');
INSERT INTO public.easypases (id, pass) VALUES (1365, 'samsung1');
INSERT INTO public.easypases (id, pass) VALUES (1366, 'deimudda123');
INSERT INTO public.easypases (id, pass) VALUES (1367, 'sommer');
INSERT INTO public.easypases (id, pass) VALUES (1368, 'ilikepie1');
INSERT INTO public.easypases (id, pass) VALUES (1369, 'qwerty12');
INSERT INTO public.easypases (id, pass) VALUES (1370, 'fuckthis');
INSERT INTO public.easypases (id, pass) VALUES (1371, 'kaka123A');
INSERT INTO public.easypases (id, pass) VALUES (1372, 'baseball');
INSERT INTO public.easypases (id, pass) VALUES (1373, '0}@5^~;%cX');
INSERT INTO public.easypases (id, pass) VALUES (1374, 'kimbo123');
INSERT INTO public.easypases (id, pass) VALUES (1375, 'niggers123');
INSERT INTO public.easypases (id, pass) VALUES (1376, 'Jonqb381998');
INSERT INTO public.easypases (id, pass) VALUES (1377, 'hugo1234');
INSERT INTO public.easypases (id, pass) VALUES (1378, 'jordie');
INSERT INTO public.easypases (id, pass) VALUES (1379, 'fucklizard');
INSERT INTO public.easypases (id, pass) VALUES (1380, 'Bitch123');
INSERT INTO public.easypases (id, pass) VALUES (1381, 'Arsenal1234');
INSERT INTO public.easypases (id, pass) VALUES (1382, 'steven');
INSERT INTO public.easypases (id, pass) VALUES (1383, 'manton123');
INSERT INTO public.easypases (id, pass) VALUES (1384, 'whatsapassword');
INSERT INTO public.easypases (id, pass) VALUES (1385, 'runescape11');
INSERT INTO public.easypases (id, pass) VALUES (1386, 'nignog');
INSERT INTO public.easypases (id, pass) VALUES (1387, 'Youwontguessit');
INSERT INTO public.easypases (id, pass) VALUES (1388, 'bro123');
INSERT INTO public.easypases (id, pass) VALUES (1389, '030292ee');
INSERT INTO public.easypases (id, pass) VALUES (1390, 'mexico');
INSERT INTO public.easypases (id, pass) VALUES (1391, 'penis3');
INSERT INTO public.easypases (id, pass) VALUES (1392, 'anon123');
INSERT INTO public.easypases (id, pass) VALUES (1393, '123qweasdzxc');
INSERT INTO public.easypases (id, pass) VALUES (1394, 'america1');
INSERT INTO public.easypases (id, pass) VALUES (1395, 'scooter123');
INSERT INTO public.easypases (id, pass) VALUES (1396, 'baseball14');
INSERT INTO public.easypases (id, pass) VALUES (1397, 'fuckyou11');
INSERT INTO public.easypases (id, pass) VALUES (1398, 'PINGAS56');
INSERT INTO public.easypases (id, pass) VALUES (1399, '12345678910');
INSERT INTO public.easypases (id, pass) VALUES (1400, 'flylikeabird3');
INSERT INTO public.easypases (id, pass) VALUES (1401, '123456789a');
INSERT INTO public.easypases (id, pass) VALUES (1402, '');
INSERT INTO public.easypases (id, pass) VALUES (1403, 'qpqpqpqp1');
INSERT INTO public.easypases (id, pass) VALUES (1404, 'district14');
INSERT INTO public.easypases (id, pass) VALUES (1405, 'sweg123');
INSERT INTO public.easypases (id, pass) VALUES (1406, 'testi');
INSERT INTO public.easypases (id, pass) VALUES (1407, 'Gloars101');
INSERT INTO public.easypases (id, pass) VALUES (1408, 'ohshit');
INSERT INTO public.easypases (id, pass) VALUES (1409, '2bon2btitq');
INSERT INTO public.easypases (id, pass) VALUES (1410, 'owen123');
INSERT INTO public.easypases (id, pass) VALUES (1411, 'trustno1');
INSERT INTO public.easypases (id, pass) VALUES (1412, 'sniper');
INSERT INTO public.easypases (id, pass) VALUES (1413, 'cora023325');
INSERT INTO public.easypases (id, pass) VALUES (1414, 'lollollol');
INSERT INTO public.easypases (id, pass) VALUES (1415, 'coolkids123');
INSERT INTO public.easypases (id, pass) VALUES (1416, 'derpderp');
INSERT INTO public.easypases (id, pass) VALUES (1417, 'Hallodavid');
INSERT INTO public.easypases (id, pass) VALUES (1418, 'qazwsx');
INSERT INTO public.easypases (id, pass) VALUES (1419, 'marques45');
INSERT INTO public.easypases (id, pass) VALUES (1420, 'zzz123123');
INSERT INTO public.easypases (id, pass) VALUES (1421, 'lolpassword');
INSERT INTO public.easypases (id, pass) VALUES (1422, '59114344');
INSERT INTO public.easypases (id, pass) VALUES (1423, 'google1');
INSERT INTO public.easypases (id, pass) VALUES (1424, 'qwert1234');
INSERT INTO public.easypases (id, pass) VALUES (1425, 'enis326');
INSERT INTO public.easypases (id, pass) VALUES (1426, 'mario123');
INSERT INTO public.easypases (id, pass) VALUES (1427, 'Liverpool11');
INSERT INTO public.easypases (id, pass) VALUES (1428, 'ford460');
INSERT INTO public.easypases (id, pass) VALUES (1429, 'Froob!23');
INSERT INTO public.easypases (id, pass) VALUES (1430, 'rebels18');
INSERT INTO public.easypases (id, pass) VALUES (1431, 'lazer123');
INSERT INTO public.easypases (id, pass) VALUES (1432, 'bananas');
INSERT INTO public.easypases (id, pass) VALUES (1433, 'yolo123');
INSERT INTO public.easypases (id, pass) VALUES (1434, 'hannazananiri');
INSERT INTO public.easypases (id, pass) VALUES (1435, 'pokemon19');
INSERT INTO public.easypases (id, pass) VALUES (1436, 'lol123lol');
INSERT INTO public.easypases (id, pass) VALUES (1437, 'Iloveyukid');
INSERT INTO public.easypases (id, pass) VALUES (1438, 'borderlands2');
INSERT INTO public.easypases (id, pass) VALUES (1439, 'qazwsx123');
INSERT INTO public.easypases (id, pass) VALUES (1440, 'admin123');
INSERT INTO public.easypases (id, pass) VALUES (1441, 'hacker123');
INSERT INTO public.easypases (id, pass) VALUES (1442, 'qwerty12345');
INSERT INTO public.easypases (id, pass) VALUES (1443, 'huehue');
INSERT INTO public.easypases (id, pass) VALUES (1444, 'theone22');
INSERT INTO public.easypases (id, pass) VALUES (1445, 'callofduty');
INSERT INTO public.easypases (id, pass) VALUES (1446, 'seaways');
INSERT INTO public.easypases (id, pass) VALUES (1447, 'lol12345678');
INSERT INTO public.easypases (id, pass) VALUES (1448, 'gxsT3Q9n8jEk9Kd');
INSERT INTO public.easypases (id, pass) VALUES (1449, 'killer12');
INSERT INTO public.easypases (id, pass) VALUES (1450, 'johnny');
INSERT INTO public.easypases (id, pass) VALUES (1451, 'adidas');
INSERT INTO public.easypases (id, pass) VALUES (1452, 'cpdudetv11');
INSERT INTO public.easypases (id, pass) VALUES (1453, 'moontoo');
INSERT INTO public.easypases (id, pass) VALUES (1454, '101010');
INSERT INTO public.easypases (id, pass) VALUES (1455, 'lollollol123');
INSERT INTO public.easypases (id, pass) VALUES (1456, '123@456');
INSERT INTO public.easypases (id, pass) VALUES (1457, '123condog');
INSERT INTO public.easypases (id, pass) VALUES (1458, 'Welkom01');
INSERT INTO public.easypases (id, pass) VALUES (1459, 'iloveashton');
INSERT INTO public.easypases (id, pass) VALUES (1460, 'trol123');
INSERT INTO public.easypases (id, pass) VALUES (1461, '789456123');
INSERT INTO public.easypases (id, pass) VALUES (1462, '9876543210');
INSERT INTO public.easypases (id, pass) VALUES (1463, 'matthew');
INSERT INTO public.easypases (id, pass) VALUES (1464, 'daniel007');
INSERT INTO public.easypases (id, pass) VALUES (1465, 'Majestic12');
INSERT INTO public.easypases (id, pass) VALUES (1466, 'lizardftw');
INSERT INTO public.easypases (id, pass) VALUES (1467, 'Azerty50');
INSERT INTO public.easypases (id, pass) VALUES (1468, 'maspro123');
INSERT INTO public.easypases (id, pass) VALUES (1469, 'ggggg');
INSERT INTO public.easypases (id, pass) VALUES (1470, 'asshat1');
INSERT INTO public.easypases (id, pass) VALUES (1471, 'testt');
INSERT INTO public.easypases (id, pass) VALUES (1472, 'password11');
INSERT INTO public.easypases (id, pass) VALUES (1473, 'propro');
INSERT INTO public.easypases (id, pass) VALUES (1474, 'matipass');
INSERT INTO public.easypases (id, pass) VALUES (1475, '7moodcool');
INSERT INTO public.easypases (id, pass) VALUES (1476, '1207AH');
INSERT INTO public.easypases (id, pass) VALUES (1477, 'Hack917');
INSERT INTO public.easypases (id, pass) VALUES (1478, 'ahmed');
INSERT INTO public.easypases (id, pass) VALUES (1479, 'sika1999');
INSERT INTO public.easypases (id, pass) VALUES (1480, 'Fergiej123');
INSERT INTO public.easypases (id, pass) VALUES (1481, 'raddenson11rulez');
INSERT INTO public.easypases (id, pass) VALUES (1482, 'nazizombies123');
INSERT INTO public.easypases (id, pass) VALUES (1483, 'lingwing');
INSERT INTO public.easypases (id, pass) VALUES (1484, 'dreamer01');
INSERT INTO public.easypases (id, pass) VALUES (1485, 'drybones3');
INSERT INTO public.easypases (id, pass) VALUES (1486, 'maaghan1');
INSERT INTO public.easypases (id, pass) VALUES (1487, 'Abc123!@#');
INSERT INTO public.easypases (id, pass) VALUES (1488, 'filipe123');
INSERT INTO public.easypases (id, pass) VALUES (1489, 'mariner99');
INSERT INTO public.easypases (id, pass) VALUES (1490, 'ruben420');
INSERT INTO public.easypases (id, pass) VALUES (1491, 'testj');
INSERT INTO public.easypases (id, pass) VALUES (1492, 'membrino00');
INSERT INTO public.easypases (id, pass) VALUES (1493, 'buffboy2000');
INSERT INTO public.easypases (id, pass) VALUES (1494, 'Myone111');
INSERT INTO public.easypases (id, pass) VALUES (1495, 'donkeredirk');
INSERT INTO public.easypases (id, pass) VALUES (1496, 'epicduck421');
INSERT INTO public.easypases (id, pass) VALUES (1497, 'jordanalaska');
INSERT INTO public.easypases (id, pass) VALUES (1498, 'anabel');
INSERT INTO public.easypases (id, pass) VALUES (1499, '13540956');
INSERT INTO public.easypases (id, pass) VALUES (1500, 'Elkinselks1');
INSERT INTO public.easypases (id, pass) VALUES (1501, 'burbage1');
INSERT INTO public.easypases (id, pass) VALUES (1502, 'nack3r3d');
INSERT INTO public.easypases (id, pass) VALUES (1503, 'revtechrevtechrevtech');
INSERT INTO public.easypases (id, pass) VALUES (1504, 'ihi4kah');
INSERT INTO public.easypases (id, pass) VALUES (1505, 'redemption1');
INSERT INTO public.easypases (id, pass) VALUES (1506, 'Kikiki123456789');
INSERT INTO public.easypases (id, pass) VALUES (1507, 'c7y8UCyFPbUK7UyRL6yUPGW');
INSERT INTO public.easypases (id, pass) VALUES (1508, 'iamcool741');
INSERT INTO public.easypases (id, pass) VALUES (1509, 'sidiaich1516');
INSERT INTO public.easypases (id, pass) VALUES (1510, '15975322');
INSERT INTO public.easypases (id, pass) VALUES (1511, 'LOLOLOL');
INSERT INTO public.easypases (id, pass) VALUES (1512, 'besopERjhsdfsd78');
INSERT INTO public.easypases (id, pass) VALUES (1513, 'ghostssucks');
INSERT INTO public.easypases (id, pass) VALUES (1514, 'mustafa00');
INSERT INTO public.easypases (id, pass) VALUES (1515, 'verydark123');
INSERT INTO public.easypases (id, pass) VALUES (1516, 'hkcsfc88');
INSERT INTO public.easypases (id, pass) VALUES (1517, 'October2332');
INSERT INTO public.easypases (id, pass) VALUES (1518, 'bibibibbiibbibi');
INSERT INTO public.easypases (id, pass) VALUES (1519, 'sadersxy');
INSERT INTO public.easypases (id, pass) VALUES (1520, 'kev96?kev96?');
INSERT INTO public.easypases (id, pass) VALUES (1521, 'drh123');
INSERT INTO public.easypases (id, pass) VALUES (1522, 'hotwheels');
INSERT INTO public.easypases (id, pass) VALUES (1523, 'Terpannie1');
INSERT INTO public.easypases (id, pass) VALUES (1524, 'Jamie2013');
INSERT INTO public.easypases (id, pass) VALUES (1525, 'kopper');
INSERT INTO public.easypases (id, pass) VALUES (1526, 'tester12');
INSERT INTO public.easypases (id, pass) VALUES (1527, 'egcast');
INSERT INTO public.easypases (id, pass) VALUES (1528, 'molly1804');
INSERT INTO public.easypases (id, pass) VALUES (1529, 'redmansgreed1');
INSERT INTO public.easypases (id, pass) VALUES (1530, 'namecid360');
INSERT INTO public.easypases (id, pass) VALUES (1531, '20000523');
INSERT INTO public.easypases (id, pass) VALUES (1532, 'Notcameron');
INSERT INTO public.easypases (id, pass) VALUES (1533, 'igor12');
INSERT INTO public.easypases (id, pass) VALUES (1534, '29987561');
INSERT INTO public.easypases (id, pass) VALUES (1535, 'laladi99');
INSERT INTO public.easypases (id, pass) VALUES (1536, 'scryptkid123');
INSERT INTO public.easypases (id, pass) VALUES (1537, '112233123aA');
INSERT INTO public.easypases (id, pass) VALUES (1538, 'puputi17');
INSERT INTO public.easypases (id, pass) VALUES (1539, 'coke123123123');
INSERT INTO public.easypases (id, pass) VALUES (1540, 'ghgh5656');
INSERT INTO public.easypases (id, pass) VALUES (1541, 'skippy07');
INSERT INTO public.easypases (id, pass) VALUES (1542, 'ehgnbobs@grr.la');
INSERT INTO public.easypases (id, pass) VALUES (1543, '46W-TF6-h8T-3L9');
INSERT INTO public.easypases (id, pass) VALUES (1544, 'Antihackers');
INSERT INTO public.easypases (id, pass) VALUES (1545, 'Onyxonyx1');
INSERT INTO public.easypases (id, pass) VALUES (1546, 'washburn21');
INSERT INTO public.easypases (id, pass) VALUES (1547, '103098mp');
INSERT INTO public.easypases (id, pass) VALUES (1548, 'cool1972002');
INSERT INTO public.easypases (id, pass) VALUES (1549, 'r0106m93.2');
INSERT INTO public.easypases (id, pass) VALUES (1550, 'Stocks123');
INSERT INTO public.easypases (id, pass) VALUES (1551, 'ianpater1');
INSERT INTO public.easypases (id, pass) VALUES (1552, 'Pauldavid1');
INSERT INTO public.easypases (id, pass) VALUES (1553, 'dennis123');
INSERT INTO public.easypases (id, pass) VALUES (1554, 'ravens4life');
INSERT INTO public.easypases (id, pass) VALUES (1555, 'Gurvir87');
INSERT INTO public.easypases (id, pass) VALUES (1556, 'suckmydick101');
INSERT INTO public.easypases (id, pass) VALUES (1557, '00jkl00');
INSERT INTO public.easypases (id, pass) VALUES (1558, 'shxds9638596');
INSERT INTO public.easypases (id, pass) VALUES (1559, 'Sabinal12');
INSERT INTO public.easypases (id, pass) VALUES (1560, 'ilovesani');
INSERT INTO public.easypases (id, pass) VALUES (1561, 'Gdre%24Fdrehhf*&ddd');
INSERT INTO public.easypases (id, pass) VALUES (1562, 'will2000');
INSERT INTO public.easypases (id, pass) VALUES (1563, 'Kalinda56');
INSERT INTO public.easypases (id, pass) VALUES (1564, 'villa335');


                                                                                                                                                                                                                    3398.dat                                                                                            0000600 0004000 0002000 00000001702 14444623724 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.logins (id, login, password) VALUES (1, 'testlogin', '$2b$10$ZBHOilHmZAeH8/P8zsLnN.xjrf7TOf5a5ByOSrHLqrEVO2oZJ14fi');
INSERT INTO public.logins (id, login, password) VALUES (5, 'mireavuz', '$2b$10$jJ0lOf8QCqr1AupJzlCKmuc/X7oJrqSuni8yim.5fT7pRKN6whvoO');
INSERT INTO public.logins (id, login, password) VALUES (6, 'mireaEvgen', '$2b$10$XcW4kbYA7Q0KWFFO0NdjKOi66OOSqJrPWHqjItGxQX0oxoHFofoWu');
INSERT INTO public.logins (id, login, password) VALUES (7, 'mireaRena', '$2b$10$ouEx6HK.0h9qbhrkrNTzDu5.otTqaDu9lgCmblHO7drTeOodrePLC');
INSERT INTO public.logins (id, login, password) VALUES (8, 'mireaMark', '$2b$10$NbzM/YfNDTQ0HygnB41oNu7gRq6.hq/Gk2pF7PCBgRRSfHLG6XFk.');
INSERT INTO public.logins (id, login, password) VALUES (9, 'mireaPav', '$2b$10$KKxAlC8mQBoDkMa9qjLeoOaqqmPkRsSXUM19QD4xzWXJanNTo6RzK');
INSERT INTO public.logins (id, login, password) VALUES (17, 'mireatest1', '$2b$10$5LAGyYgE2kstCo/scyEarOc0m6TlcX8oQ5DEJ6sye.s4NLDarnI8y');


                                                              3393.dat                                                                                            0000600 0004000 0002000 00000000235 14444623724 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.marks (user_id, place_id, label) VALUES (5, 2, 'blacklist');
INSERT INTO public.marks (user_id, place_id, label) VALUES (5, 1, 'like');


                                                                                                                                                                                                                                                                                                                                                                   3394.dat                                                                                            0000600 0004000 0002000 00000001372 14444623724 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.places (id, title, description, pointlan, pointlon) VALUES (1, 'Поляна 1389', 'Курорт', 43.695849, 40.317521);
INSERT INTO public.places (id, title, description, pointlan, pointlon) VALUES (2, 'Ранхигс', 'ВУЗ', 55.667178, 37.479043);
INSERT INTO public.places (id, title, description, pointlan, pointlon) VALUES (3, ' Роза Хутор', 'Лыжная база', 43.656107, 40.323867);
INSERT INTO public.places (id, title, description, pointlan, pointlon) VALUES (4, 'Турклуб Camp2050', 'Турестическая база', 43.642043, 40.253452);
INSERT INTO public.places (id, title, description, pointlan, pointlon) VALUES (5, 'Рыбино', 'Турестическая база', 43.697991, 40.178755);


                                                                                                                                                                                                                                                                      3395.dat                                                                                            0000600 0004000 0002000 00000000734 14444623724 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.reviews (id, title, description, user_id, place_id) VALUES (1, 'Посетил Поляну', 'Очень понравилось', 1, 1);
INSERT INTO public.reviews (id, title, description, user_id, place_id) VALUES (2, 'Посетил Ранхигс', 'Не понравилось', 6, 2);
INSERT INTO public.reviews (id, title, description, user_id, place_id) VALUES (3, 'Учусь в Ранхигсе', 'Не нравится учиться', 17, 2);


                                    3402.dat                                                                                            0000600 0004000 0002000 00000000403 14444623724 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.tokens (id, token, user_id, login_id) VALUES (38, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbiI6InRlc3Rsb2dpbiIsInRpbWUiOiIyMDIzLTA2LTIxVDE2OjIzOjM5LjIzOVoiLCJpYXQiOjE2ODczNjQ2MTl9.WyYpexH5t2COTuYHPFsIatgQ2IIx3d6eEAQcm7KTT-g', 1, 1);


                                                                                                                                                                                                                                                             3404.dat                                                                                            0000600 0004000 0002000 00000002035 14444623724 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (1, 'alze', 'elza', '+79232335070', 'eve@123', 31, 1);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (5, 'student', 'mirea', '+74992156565', 'student@edu.mirea.ru', 76, 5);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (6, 'Evgeny', 'Onyshenko', '+7499xxxzzyy', 'student@edu.mirea.ru', 21, 6);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (7, 'Renata', 'Valeeva', '+7499xxxzzyy', 'student@edu.mirea.ru', 20, 7);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (8, 'Mark', 'Bochkarev', '+7499xxxzzyy', 'student@edu.mirea.ru', 20, 8);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (9, 'Pavel', 'Redkin', '+7499xxxzzyy', 'student@edu.mirea.ru', 20, 9);
INSERT INTO public.users (id, name, surname, phone, email, age, login_id) VALUES (17, 'Test', 'Student', '+79990002121', 'eve@mirea.ru', 13, 17);


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   restore.sql                                                                                         0000600 0004000 0002000 00000042515 14444623724 0015405 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

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

DROP DATABASE course;
--
-- Name: course; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE course WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE course OWNER TO postgres;

\connect course

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

--
-- Name: labels; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.labels AS ENUM (
    'none',
    'like',
    'blacklist'
);


ALTER TYPE public.labels OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: marks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marks (
    user_id integer NOT NULL,
    place_id integer NOT NULL,
    label public.labels NOT NULL
);


ALTER TABLE public.marks OWNER TO postgres;

--
-- Name: places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.places (
    id integer NOT NULL,
    title character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    pointlan double precision NOT NULL,
    pointlon double precision NOT NULL
);


ALTER TABLE public.places OWNER TO postgres;

--
-- Name: blacklist_places; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.blacklist_places AS
 SELECT places.id,
    places.title,
    places.description,
    marks.user_id,
    marks.place_id
   FROM public.places,
    public.marks
  WHERE ((marks.label = 'blacklist'::public.labels) AND (marks.place_id = places.id));


ALTER TABLE public.blacklist_places OWNER TO postgres;

--
-- Name: find_blacklist(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_blacklist(uid integer) RETURNS SETOF public.blacklist_places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from blacklist_places where user_id = uid;
end; 
$$;


ALTER FUNCTION public.find_blacklist(uid integer) OWNER TO postgres;

--
-- Name: like_places; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.like_places AS
 SELECT places.id,
    places.title,
    places.description,
    marks.user_id,
    marks.place_id
   FROM public.places,
    public.marks
  WHERE ((marks.label = 'like'::public.labels) AND (marks.place_id = places.id));


ALTER TABLE public.like_places OWNER TO postgres;

--
-- Name: find_like(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_like(uid integer) RETURNS SETOF public.like_places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from like_places where user_id = uid;
end; 
$$;


ALTER FUNCTION public.find_like(uid integer) OWNER TO postgres;

--
-- Name: get_all_places(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_places(uid integer) RETURNS SETOF public.places
    LANGUAGE plpgsql
    AS $$
begin
return query select * from places where id not in (select place_id from blacklist_places where user_id = uid);
end; $$;


ALTER FUNCTION public.get_all_places(uid integer) OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    title character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    user_id integer NOT NULL,
    place_id integer NOT NULL
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: get_reviews_byplace(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_reviews_byplace(pid integer) RETURNS SETOF public.reviews
    LANGUAGE plpgsql
    AS $$
begin
return query select * from reviews where place_id = pid;
end; $$;


ALTER FUNCTION public.get_reviews_byplace(pid integer) OWNER TO postgres;

--
-- Name: get_reviews_byuser(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_reviews_byuser(uid integer) RETURNS SETOF public.reviews
    LANGUAGE plpgsql
    AS $$
begin
return query select * from reviews where user_id = uid;
end; $$;


ALTER FUNCTION public.get_reviews_byuser(uid integer) OWNER TO postgres;

--
-- Name: label_func(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.label_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if new.label = 'none'then
delete from marks where user_id = new.user_id and place_id = new.place_id;
return null;
end if;
if new.label = 'like' then
return new;
end if;
if new.label = 'blacklist' then
return new;
end if;
end;
$$;


ALTER FUNCTION public.label_func() OWNER TO postgres;

--
-- Name: set_label(integer, integer, public.labels); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels)
    LANGUAGE plpgsql
    AS $$
begin
update marks set label=p_label where user_id = u_id and place_id = p_id;
end; 
$$;


ALTER PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels) OWNER TO postgres;

--
-- Name: easypases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.easypases (
    id integer NOT NULL,
    pass character varying(30) NOT NULL
);


ALTER TABLE public.easypases OWNER TO postgres;

--
-- Name: easypases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.easypases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.easypases_id_seq OWNER TO postgres;

--
-- Name: easypases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.easypases_id_seq OWNED BY public.easypases.id;


--
-- Name: logins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logins (
    id integer NOT NULL,
    login character varying(30) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.logins OWNER TO postgres;

--
-- Name: logins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logins_id_seq OWNER TO postgres;

--
-- Name: logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logins_id_seq OWNED BY public.logins.id;


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.places_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.places_id_seq OWNER TO postgres;

--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    user_id integer NOT NULL,
    login_id integer NOT NULL
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    phone character varying(12) NOT NULL,
    email character varying(40) NOT NULL,
    age smallint NOT NULL,
    login_id integer NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: easypases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.easypases ALTER COLUMN id SET DEFAULT nextval('public.easypases_id_seq'::regclass);


--
-- Name: logins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);


--
-- Name: places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: easypases; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3396.dat

--
-- Data for Name: logins; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3398.dat

--
-- Data for Name: marks; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3393.dat

--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3394.dat

--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3395.dat

--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3402.dat

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

\i $$PATH$$/3404.dat

--
-- Name: easypases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.easypases_id_seq', 1564, true);


--
-- Name: logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logins_id_seq', 20, true);


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.places_id_seq', 5, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_id_seq', 38, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 20, true);


--
-- Name: easypases easypases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.easypases
    ADD CONSTRAINT easypases_pkey PRIMARY KEY (id);


--
-- Name: logins logins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);


--
-- Name: marks mark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_pkey PRIMARY KEY (user_id, place_id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: pass_inx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pass_inx ON public.easypases USING hash (pass);


--
-- Name: marks label_trg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER label_trg BEFORE UPDATE OF label ON public.marks FOR EACH ROW EXECUTE FUNCTION public.label_func();


--
-- Name: marks mark_place; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_place FOREIGN KEY (place_id) REFERENCES public.places(id) NOT VALID;


--
-- Name: marks mark_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT mark_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- Name: reviews review_place; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT review_place FOREIGN KEY (place_id) REFERENCES public.places(id) NOT VALID;


--
-- Name: reviews review_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT review_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- Name: tokens token_login; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT token_login FOREIGN KEY (login_id) REFERENCES public.logins(id) NOT VALID;


--
-- Name: tokens token_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT token_user FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- Name: users user_login; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_login FOREIGN KEY (login_id) REFERENCES public.logins(id) NOT VALID;


--
-- Name: FUNCTION label_func(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.label_func() TO userdb;


--
-- Name: PROCEDURE set_label(IN u_id integer, IN p_id integer, IN p_label public.labels); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON PROCEDURE public.set_label(IN u_id integer, IN p_id integer, IN p_label public.labels) TO userdb;


--
-- Name: TABLE easypases; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.easypases TO admindb;


--
-- Name: SEQUENCE easypases_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.easypases_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.easypases_id_seq TO admindb;


--
-- Name: SEQUENCE logins_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.logins_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.logins_id_seq TO admindb;


--
-- Name: SEQUENCE places_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.places_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.places_id_seq TO admindb;


--
-- Name: SEQUENCE reviews_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.reviews_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.reviews_id_seq TO admindb;


--
-- Name: TABLE tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT DELETE ON TABLE public.tokens TO userdb;
GRANT ALL ON TABLE public.tokens TO admindb;


--
-- Name: COLUMN tokens.token; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(token) ON TABLE public.tokens TO userdb;


--
-- Name: COLUMN tokens.user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(user_id) ON TABLE public.tokens TO userdb;


--
-- Name: SEQUENCE tokens_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.tokens_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.tokens_id_seq TO admindb;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.users TO userdb;
GRANT ALL ON TABLE public.users TO admindb;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO userdb;
GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO admindb;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   