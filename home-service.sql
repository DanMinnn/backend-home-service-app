--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-06-25 10:14:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 43780)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 5415 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 2 (class 3079 OID 43891)
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- TOC entry 3 (class 3079 OID 43980)
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- TOC entry 982 (class 1247 OID 45112)
-- Name: availability_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.availability_status AS ENUM (
    'available',
    'busy',
    'offline'
);


ALTER TYPE public.availability_status OWNER TO postgres;

--
-- TOC entry 985 (class 1247 OID 45120)
-- Name: booking_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.booking_status AS ENUM (
    'pending',
    'assigned',
    'in_progress',
    'completed',
    'cancelled',
    'rescheduled'
);


ALTER TYPE public.booking_status OWNER TO postgres;

--
-- TOC entry 988 (class 1247 OID 45134)
-- Name: cancelled_by_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.cancelled_by_type AS ENUM (
    'user',
    'tasker',
    'admin',
    'completed'
);


ALTER TYPE public.cancelled_by_type OWNER TO postgres;

--
-- TOC entry 991 (class 1247 OID 45142)
-- Name: changed_by_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.changed_by_type AS ENUM (
    'user',
    'tasker',
    'admin',
    'system'
);


ALTER TYPE public.changed_by_type OWNER TO postgres;

--
-- TOC entry 994 (class 1247 OID 45152)
-- Name: earning_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.earning_status AS ENUM (
    'pending',
    'paid',
    'cancelled'
);


ALTER TYPE public.earning_status OWNER TO postgres;

--
-- TOC entry 1084 (class 1247 OID 45869)
-- Name: method_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.method_type AS ENUM (
    'cash',
    'vnpay',
    'bank_transfer'
);


ALTER TYPE public.method_type OWNER TO postgres;

--
-- TOC entry 1078 (class 1247 OID 45792)
-- Name: notification_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_status AS ENUM (
    'sent',
    'accepted',
    'rejected'
);


ALTER TYPE public.notification_status OWNER TO postgres;

--
-- TOC entry 1114 (class 1247 OID 46105)
-- Name: notification_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_type AS ENUM (
    'NEW_TASK',
    'JOB_ACCEPTED',
    'JOB_COMPLETED',
    'JOB_CANCELLED',
    'PAYMENT_RECEIVED',
    'RATING_RECEIVED',
    'SYSTEM_ANNOUNCEMENT'
);


ALTER TYPE public.notification_type OWNER TO postgres;

--
-- TOC entry 973 (class 1247 OID 45088)
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'pending',
    'completed',
    'failed',
    'refunded',
    'partial_refund'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- TOC entry 997 (class 1247 OID 45160)
-- Name: payout_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payout_status AS ENUM (
    'pending',
    'processed',
    'failed'
);


ALTER TYPE public.payout_status OWNER TO postgres;

--
-- TOC entry 1009 (class 1247 OID 45190)
-- Name: price_unit_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.price_unit_type AS ENUM (
    'fixed',
    'hourly'
);


ALTER TYPE public.price_unit_type OWNER TO postgres;

--
-- TOC entry 1006 (class 1247 OID 45182)
-- Name: recipient_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.recipient_type AS ENUM (
    'user',
    'tasker',
    'admin'
);


ALTER TYPE public.recipient_type OWNER TO postgres;

--
-- TOC entry 1000 (class 1247 OID 45168)
-- Name: reviewer_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reviewer_type AS ENUM (
    'user',
    'tasker'
);


ALTER TYPE public.reviewer_type OWNER TO postgres;

--
-- TOC entry 1003 (class 1247 OID 45174)
-- Name: sender_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sender_type AS ENUM (
    'user',
    'tasker',
    'system'
);


ALTER TYPE public.sender_type OWNER TO postgres;

--
-- TOC entry 1096 (class 1247 OID 45928)
-- Name: transaction_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_status AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED'
);


ALTER TYPE public.transaction_status OWNER TO postgres;

--
-- TOC entry 1093 (class 1247 OID 45921)
-- Name: transaction_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_type AS ENUM (
    'INCOME',
    'WITHDRAW',
    'ADJUSTMENT'
);


ALTER TYPE public.transaction_type OWNER TO postgres;

--
-- TOC entry 1111 (class 1247 OID 46075)
-- Name: transaction_type_user; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_type_user AS ENUM (
    'deposit',
    'payment',
    'refund'
);


ALTER TYPE public.transaction_type_user OWNER TO postgres;

--
-- TOC entry 979 (class 1247 OID 45106)
-- Name: user_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_type AS ENUM (
    'customer',
    'admin'
);


ALTER TYPE public.user_type OWNER TO postgres;

--
-- TOC entry 976 (class 1247 OID 45100)
-- Name: verification_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.verification_type AS ENUM (
    'email',
    'phone'
);


ALTER TYPE public.verification_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 236 (class 1259 OID 45300)
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    tasker_id integer,
    service_id integer NOT NULL,
    address_name text NOT NULL,
    status public.booking_status NOT NULL,
    notes text,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    cancellation_reason text,
    cancelled_by public.cancelled_by_type,
    is_recurring boolean DEFAULT false,
    recurring_pattern character varying(50),
    house_number text,
    total_price numeric(10,0),
    completed_at timestamp(6) without time zone DEFAULT now(),
    latitude numeric(10,8),
    longitude numeric(11,8),
    payment_status text,
    task_details jsonb,
    package_id integer,
    scheduled_start timestamp without time zone,
    scheduled_end timestamp without time zone,
    duration_minutes integer
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 45299)
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO postgres;

--
-- TOC entry 5419 (class 0 OID 0)
-- Dependencies: 235
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- TOC entry 248 (class 1259 OID 45386)
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_messages (
    id integer NOT NULL,
    room_id integer NOT NULL,
    sender_type public.sender_type NOT NULL,
    sender_id integer NOT NULL,
    message_text text NOT NULL,
    sent_at timestamp(6) without time zone DEFAULT now(),
    read_at timestamp without time zone
);


ALTER TABLE public.chat_messages OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 45385)
-- Name: chat_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_messages_id_seq OWNER TO postgres;

--
-- TOC entry 5420 (class 0 OID 0)
-- Dependencies: 247
-- Name: chat_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_messages_id_seq OWNED BY public.chat_messages.id;


--
-- TOC entry 246 (class 1259 OID 45375)
-- Name: chat_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_rooms (
    id integer NOT NULL,
    booking_id integer,
    user_id integer NOT NULL,
    tasker_id integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    last_message_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.chat_rooms OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 45374)
-- Name: chat_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_rooms_id_seq OWNER TO postgres;

--
-- TOC entry 5421 (class 0 OID 0)
-- Dependencies: 245
-- Name: chat_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_rooms_id_seq OWNED BY public.chat_rooms.id;


--
-- TOC entry 260 (class 1259 OID 45491)
-- Name: chatbot_interactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatbot_interactions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    query text NOT NULL,
    response text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.chatbot_interactions OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 45490)
-- Name: chatbot_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chatbot_interactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chatbot_interactions_id_seq OWNER TO postgres;

--
-- TOC entry 5422 (class 0 OID 0)
-- Dependencies: 259
-- Name: chatbot_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatbot_interactions_id_seq OWNED BY public.chatbot_interactions.id;


--
-- TOC entry 226 (class 1259 OID 45244)
-- Name: favorite_tasker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorite_tasker (
    id integer NOT NULL,
    user_id integer NOT NULL,
    tasker_id integer NOT NULL,
    service_id integer NOT NULL
);


ALTER TABLE public.favorite_tasker OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 45243)
-- Name: favorite_tasker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favorite_tasker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favorite_tasker_id_seq OWNER TO postgres;

--
-- TOC entry 5423 (class 0 OID 0)
-- Dependencies: 225
-- Name: favorite_tasker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favorite_tasker_id_seq OWNED BY public.favorite_tasker.id;


--
-- TOC entry 284 (class 1259 OID 46142)
-- Name: fcm_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fcm_tokens (
    id integer NOT NULL,
    token text NOT NULL,
    user_id integer,
    tasker_id integer,
    device_id text,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.fcm_tokens OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 46141)
-- Name: fcm_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fcm_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fcm_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 5424 (class 0 OID 0)
-- Dependencies: 283
-- Name: fcm_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fcm_tokens_id_seq OWNED BY public.fcm_tokens.id;


--
-- TOC entry 261 (class 1259 OID 45744)
-- Name: global_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.global_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.global_user_id_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 46017)
-- Name: package_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package_variants (
    id integer NOT NULL,
    package_id integer NOT NULL,
    variant_name text NOT NULL,
    variant_description text,
    additional_price numeric,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.package_variants OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 46015)
-- Name: package_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.package_variants_id_seq OWNER TO postgres;

--
-- TOC entry 5425 (class 0 OID 0)
-- Dependencies: 275
-- Name: package_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_variants_id_seq OWNED BY public.package_variants.id;


--
-- TOC entry 276 (class 1259 OID 46016)
-- Name: package_variants_package_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_variants_package_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.package_variants_package_id_seq OWNER TO postgres;

--
-- TOC entry 5426 (class 0 OID 0)
-- Dependencies: 276
-- Name: package_variants_package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_variants_package_id_seq OWNED BY public.package_variants.package_id;


--
-- TOC entry 238 (class 1259 OID 45333)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    user_id integer NOT NULL,
    tasker_id integer,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'VND'::character varying,
    status public.payment_status NOT NULL,
    transaction_id character varying(255),
    payment_date timestamp without time zone,
    refund_amount numeric(10,2) DEFAULT 0,
    refund_reason text,
    refund_date timestamp without time zone,
    payment_gateway character varying(50) NOT NULL,
    gateway_response text,
    receipt_url character varying(255),
    method_type public.method_type
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 45332)
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- TOC entry 5427 (class 0 OID 0)
-- Dependencies: 237
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- TOC entry 256 (class 1259 OID 45441)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    methods character varying(100) NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT now(),
    method_path text
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 45440)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5428 (class 0 OID 0)
-- Dependencies: 255
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 288 (class 1259 OID 46246)
-- Name: review_features; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_features (
    id bigint,
    sentiment_label double precision,
    sentiment_confidence double precision,
    reputation_score double precision
);


ALTER TABLE public.review_features OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 46234)
-- Name: review_sentiment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_sentiment (
    id bigint,
    sentiment_score double precision
);


ALTER TABLE public.review_sentiment OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 45362)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    reviewer_id integer NOT NULL,
    reviewer_type public.reviewer_type NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 45361)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- TOC entry 5429 (class 0 OID 0)
-- Dependencies: 243
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 257 (class 1259 OID 45452)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 45835)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5430 (class 0 OID 0)
-- Dependencies: 263
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 254 (class 1259 OID 45428)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 45427)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5431 (class 0 OID 0)
-- Dependencies: 253
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 285 (class 1259 OID 46229)
-- Name: sentiment_analysis_detailed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sentiment_analysis_detailed (
    id bigint,
    comment text,
    rating bigint,
    bart_sentiment double precision,
    bart_confidence double precision,
    keyword_sentiment double precision,
    keyword_confidence double precision,
    sentiment_label double precision,
    sentiment_confidence double precision
);


ALTER TABLE public.sentiment_analysis_detailed OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 45253)
-- Name: service_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.service_categories OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 45252)
-- Name: service_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_categories_id_seq OWNER TO postgres;

--
-- TOC entry 5432 (class 0 OID 0)
-- Dependencies: 227
-- Name: service_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_categories_id_seq OWNED BY public.service_categories.id;


--
-- TOC entry 274 (class 1259 OID 46001)
-- Name: service_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_packages (
    id integer NOT NULL,
    service_id integer NOT NULL,
    name text NOT NULL,
    description text,
    base_price numeric,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.service_packages OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 45999)
-- Name: service_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_packages_id_seq OWNER TO postgres;

--
-- TOC entry 5433 (class 0 OID 0)
-- Dependencies: 272
-- Name: service_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_packages_id_seq OWNED BY public.service_packages.id;


--
-- TOC entry 273 (class 1259 OID 46000)
-- Name: service_packages_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_packages_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_packages_service_id_seq OWNER TO postgres;

--
-- TOC entry 5434 (class 0 OID 0)
-- Dependencies: 273
-- Name: service_packages_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_packages_service_id_seq OWNED BY public.service_packages.service_id;


--
-- TOC entry 230 (class 1259 OID 45264)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    icon character varying(100),
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 45263)
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_id_seq OWNER TO postgres;

--
-- TOC entry 5435 (class 0 OID 0)
-- Dependencies: 229
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- TOC entry 222 (class 1259 OID 45217)
-- Name: tasker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker (
    id integer DEFAULT nextval('public.global_user_id_seq'::regclass) NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(15) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_last_name character varying(100) NOT NULL,
    profile_image character varying(255),
    address text,
    latitude numeric(10,8),
    longitude numeric(11,8),
    average_rating numeric(3,2) DEFAULT 0,
    total_earnings numeric(10,2) DEFAULT 0,
    availability_status public.availability_status NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    last_login timestamp without time zone,
    is_verified boolean DEFAULT false,
    is_active boolean DEFAULT true
);


ALTER TABLE public.tasker OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 45344)
-- Name: tasker_earnings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_earnings (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    platform_fee numeric(10,2) NOT NULL,
    net_amount numeric(10,2) NOT NULL,
    status public.earning_status NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    paid_at timestamp without time zone
);


ALTER TABLE public.tasker_earnings OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 45343)
-- Name: tasker_earnings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_earnings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_earnings_id_seq OWNER TO postgres;

--
-- TOC entry 5436 (class 0 OID 0)
-- Dependencies: 239
-- Name: tasker_earnings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_earnings_id_seq OWNED BY public.tasker_earnings.id;


--
-- TOC entry 291 (class 1259 OID 46262)
-- Name: tasker_exposure_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_exposure_stats (
    id integer NOT NULL,
    tasker_id integer,
    notification_count integer,
    assigned_job_count integer,
    registration_date timestamp(6) without time zone,
    last_job_date timestamp(6) without time zone,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.tasker_exposure_stats OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 46261)
-- Name: tasker_exposure_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_exposure_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_exposure_stats_id_seq OWNER TO postgres;

--
-- TOC entry 5437 (class 0 OID 0)
-- Dependencies: 290
-- Name: tasker_exposure_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_exposure_stats_id_seq OWNED BY public.tasker_exposure_stats.id;


--
-- TOC entry 221 (class 1259 OID 45216)
-- Name: tasker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_id_seq OWNER TO postgres;

--
-- TOC entry 5438 (class 0 OID 0)
-- Dependencies: 221
-- Name: tasker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_id_seq OWNED BY public.tasker.id;


--
-- TOC entry 282 (class 1259 OID 46131)
-- Name: tasker_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_notification (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    booking_id integer NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    notification_type public.notification_type NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.tasker_notification OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 46130)
-- Name: tasker_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_notification_id_seq OWNER TO postgres;

--
-- TOC entry 5439 (class 0 OID 0)
-- Dependencies: 281
-- Name: tasker_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_notification_id_seq OWNED BY public.tasker_notification.id;


--
-- TOC entry 242 (class 1259 OID 45352)
-- Name: tasker_payouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_payouts (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payout_method character varying(50) NOT NULL,
    account_details text NOT NULL,
    status public.payout_status NOT NULL,
    transaction_id character varying(255),
    request_date timestamp(6) without time zone DEFAULT now(),
    process_date timestamp without time zone,
    notes text
);


ALTER TABLE public.tasker_payouts OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 45351)
-- Name: tasker_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_payouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_payouts_id_seq OWNER TO postgres;

--
-- TOC entry 5440 (class 0 OID 0)
-- Dependencies: 241
-- Name: tasker_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_payouts_id_seq OWNED BY public.tasker_payouts.id;


--
-- TOC entry 287 (class 1259 OID 46243)
-- Name: tasker_reputation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_reputation (
    tasker_id double precision,
    reputation_score double precision,
    id integer NOT NULL
);


ALTER TABLE public.tasker_reputation OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 46249)
-- Name: tasker_reputation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasker_reputation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tasker_reputation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 262 (class 1259 OID 45812)
-- Name: tasker_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_roles (
    tasker_id integer NOT NULL,
    role_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.tasker_roles OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 45857)
-- Name: tasker_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_roles_id_seq OWNER TO postgres;

--
-- TOC entry 5441 (class 0 OID 0)
-- Dependencies: 265
-- Name: tasker_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_roles_id_seq OWNED BY public.tasker_roles.id;


--
-- TOC entry 232 (class 1259 OID 45276)
-- Name: tasker_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_services (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    service_id integer NOT NULL,
    is_verified boolean DEFAULT false,
    tasker_name text,
    service_name text
);


ALTER TABLE public.tasker_services OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 45275)
-- Name: tasker_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_services_id_seq OWNER TO postgres;

--
-- TOC entry 5442 (class 0 OID 0)
-- Dependencies: 231
-- Name: tasker_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_services_id_seq OWNED BY public.tasker_services.id;


--
-- TOC entry 271 (class 1259 OID 45936)
-- Name: tasker_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_transaction (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    amount numeric(10,2) DEFAULT 0,
    type public.transaction_type,
    status public.transaction_status,
    description text,
    created_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.tasker_transaction OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 45935)
-- Name: tasker_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_transaction_id_seq OWNER TO postgres;

--
-- TOC entry 5443 (class 0 OID 0)
-- Dependencies: 270
-- Name: tasker_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_transaction_id_seq OWNED BY public.tasker_transaction.id;


--
-- TOC entry 252 (class 1259 OID 45409)
-- Name: tasker_unavailable_dates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_unavailable_dates (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    reason character varying(255)
);


ALTER TABLE public.tasker_unavailable_dates OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 45408)
-- Name: tasker_unavailable_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_unavailable_dates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_unavailable_dates_id_seq OWNER TO postgres;

--
-- TOC entry 5444 (class 0 OID 0)
-- Dependencies: 251
-- Name: tasker_unavailable_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_unavailable_dates_id_seq OWNED BY public.tasker_unavailable_dates.id;


--
-- TOC entry 269 (class 1259 OID 45901)
-- Name: tasker_wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasker_wallet (
    id integer NOT NULL,
    tasker_id integer NOT NULL,
    balance numeric(10,2) DEFAULT 0,
    updated_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.tasker_wallet OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 45900)
-- Name: tasker_wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasker_wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasker_wallet_id_seq OWNER TO postgres;

--
-- TOC entry 5445 (class 0 OID 0)
-- Dependencies: 268
-- Name: tasker_wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasker_wallet_id_seq OWNED BY public.tasker_wallet.id;


--
-- TOC entry 234 (class 1259 OID 45288)
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_addresses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address_name character varying(255) NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8),
    is_default boolean DEFAULT false,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    apartment_type character varying(100),
    houser_number character varying(100)
);


ALTER TABLE public.user_addresses OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 45287)
-- Name: user_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_addresses_id_seq OWNER TO postgres;

--
-- TOC entry 5446 (class 0 OID 0)
-- Dependencies: 233
-- Name: user_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;


--
-- TOC entry 280 (class 1259 OID 46120)
-- Name: user_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    booking_id integer NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    notification_type public.notification_type NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.user_notifications OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 46119)
-- Name: user_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_notifications_id_seq OWNER TO postgres;

--
-- TOC entry 5447 (class 0 OID 0)
-- Dependencies: 279
-- Name: user_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_notifications_id_seq OWNED BY public.user_notifications.id;


--
-- TOC entry 250 (class 1259 OID 45397)
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_preferences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    service_category_id integer NOT NULL,
    preference_level integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    CONSTRAINT user_preferences_preference_level_check CHECK (((preference_level >= 1) AND (preference_level <= 5)))
);


ALTER TABLE public.user_preferences OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 45396)
-- Name: user_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_preferences_id_seq OWNER TO postgres;

--
-- TOC entry 5448 (class 0 OID 0)
-- Dependencies: 249
-- Name: user_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_preferences_id_seq OWNED BY public.user_preferences.id;


--
-- TOC entry 258 (class 1259 OID 45457)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 45846)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_id_seq OWNER TO postgres;

--
-- TOC entry 5449 (class 0 OID 0)
-- Dependencies: 264
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- TOC entry 278 (class 1259 OID 46059)
-- Name: user_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT now(),
    transaction_type public.transaction_type_user,
    CONSTRAINT user_transaction_amount_check CHECK ((amount <> (0)::numeric))
);


ALTER TABLE public.user_transaction OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 45234)
-- Name: user_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_verifications (
    id integer NOT NULL,
    user_id integer,
    tasker_id integer,
    verification_code character varying(10) NOT NULL,
    verification_type public.verification_type NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    expires_at timestamp(6) without time zone NOT NULL,
    is_used boolean DEFAULT false,
    CONSTRAINT user_or_tasker_check CHECK ((((user_id IS NULL) AND (tasker_id IS NOT NULL)) OR ((user_id IS NOT NULL) AND (tasker_id IS NULL))))
);


ALTER TABLE public.user_verifications OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 45233)
-- Name: user_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_verifications_id_seq OWNER TO postgres;

--
-- TOC entry 5450 (class 0 OID 0)
-- Dependencies: 223
-- Name: user_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_verifications_id_seq OWNED BY public.user_verifications.id;


--
-- TOC entry 267 (class 1259 OID 45892)
-- Name: user_wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_wallet (
    id integer NOT NULL,
    user_id integer NOT NULL,
    balance numeric(10,2) DEFAULT 0,
    updated_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.user_wallet OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 45891)
-- Name: user_wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_wallet_id_seq OWNER TO postgres;

--
-- TOC entry 5451 (class 0 OID 0)
-- Dependencies: 266
-- Name: user_wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_wallet_id_seq OWNED BY public.user_wallet.id;


--
-- TOC entry 220 (class 1259 OID 45196)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.global_user_id_seq'::regclass) NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(15) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_last_name character varying(100) NOT NULL,
    profile_image character varying(255),
    address text,
    user_type public.user_type NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone DEFAULT now(),
    last_login timestamp without time zone,
    is_verified boolean DEFAULT false,
    is_active boolean DEFAULT true
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 45195)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5452 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4981 (class 2604 OID 45303)
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- TOC entry 4999 (class 2604 OID 45389)
-- Name: chat_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages ALTER COLUMN id SET DEFAULT nextval('public.chat_messages_id_seq'::regclass);


--
-- TOC entry 4996 (class 2604 OID 45378)
-- Name: chat_rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms ALTER COLUMN id SET DEFAULT nextval('public.chat_rooms_id_seq'::regclass);


--
-- TOC entry 5012 (class 2604 OID 45494)
-- Name: chatbot_interactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatbot_interactions ALTER COLUMN id SET DEFAULT nextval('public.chatbot_interactions_id_seq'::regclass);


--
-- TOC entry 4966 (class 2604 OID 45247)
-- Name: favorite_tasker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker ALTER COLUMN id SET DEFAULT nextval('public.favorite_tasker_id_seq'::regclass);


--
-- TOC entry 5038 (class 2604 OID 46145)
-- Name: fcm_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fcm_tokens ALTER COLUMN id SET DEFAULT nextval('public.fcm_tokens_id_seq'::regclass);


--
-- TOC entry 5027 (class 2604 OID 46020)
-- Name: package_variants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_variants ALTER COLUMN id SET DEFAULT nextval('public.package_variants_id_seq'::regclass);


--
-- TOC entry 5028 (class 2604 OID 46021)
-- Name: package_variants package_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_variants ALTER COLUMN package_id SET DEFAULT nextval('public.package_variants_package_id_seq'::regclass);


--
-- TOC entry 4986 (class 2604 OID 45336)
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- TOC entry 5008 (class 2604 OID 45444)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 4993 (class 2604 OID 45365)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 5010 (class 2604 OID 45836)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 5005 (class 2604 OID 45431)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4967 (class 2604 OID 45256)
-- Name: service_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_categories ALTER COLUMN id SET DEFAULT nextval('public.service_categories_id_seq'::regclass);


--
-- TOC entry 5024 (class 2604 OID 46004)
-- Name: service_packages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_packages ALTER COLUMN id SET DEFAULT nextval('public.service_packages_id_seq'::regclass);


--
-- TOC entry 5025 (class 2604 OID 46005)
-- Name: service_packages service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_packages ALTER COLUMN service_id SET DEFAULT nextval('public.service_packages_service_id_seq'::regclass);


--
-- TOC entry 4970 (class 2604 OID 45267)
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- TOC entry 4989 (class 2604 OID 45347)
-- Name: tasker_earnings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_earnings ALTER COLUMN id SET DEFAULT nextval('public.tasker_earnings_id_seq'::regclass);


--
-- TOC entry 5041 (class 2604 OID 46265)
-- Name: tasker_exposure_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_exposure_stats ALTER COLUMN id SET DEFAULT nextval('public.tasker_exposure_stats_id_seq'::regclass);


--
-- TOC entry 5035 (class 2604 OID 46134)
-- Name: tasker_notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_notification ALTER COLUMN id SET DEFAULT nextval('public.tasker_notification_id_seq'::regclass);


--
-- TOC entry 4991 (class 2604 OID 45355)
-- Name: tasker_payouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_payouts ALTER COLUMN id SET DEFAULT nextval('public.tasker_payouts_id_seq'::regclass);


--
-- TOC entry 5014 (class 2604 OID 45858)
-- Name: tasker_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_roles ALTER COLUMN id SET DEFAULT nextval('public.tasker_roles_id_seq'::regclass);


--
-- TOC entry 4975 (class 2604 OID 45279)
-- Name: tasker_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_services ALTER COLUMN id SET DEFAULT nextval('public.tasker_services_id_seq'::regclass);


--
-- TOC entry 5021 (class 2604 OID 45939)
-- Name: tasker_transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_transaction ALTER COLUMN id SET DEFAULT nextval('public.tasker_transaction_id_seq'::regclass);


--
-- TOC entry 5004 (class 2604 OID 45412)
-- Name: tasker_unavailable_dates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_unavailable_dates ALTER COLUMN id SET DEFAULT nextval('public.tasker_unavailable_dates_id_seq'::regclass);


--
-- TOC entry 5018 (class 2604 OID 45904)
-- Name: tasker_wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_wallet ALTER COLUMN id SET DEFAULT nextval('public.tasker_wallet_id_seq'::regclass);


--
-- TOC entry 4977 (class 2604 OID 45291)
-- Name: user_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);


--
-- TOC entry 5032 (class 2604 OID 46123)
-- Name: user_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notifications ALTER COLUMN id SET DEFAULT nextval('public.user_notifications_id_seq'::regclass);


--
-- TOC entry 5001 (class 2604 OID 45400)
-- Name: user_preferences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preferences ALTER COLUMN id SET DEFAULT nextval('public.user_preferences_id_seq'::regclass);


--
-- TOC entry 5011 (class 2604 OID 45847)
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- TOC entry 4963 (class 2604 OID 45237)
-- Name: user_verifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_verifications ALTER COLUMN id SET DEFAULT nextval('public.user_verifications_id_seq'::regclass);


--
-- TOC entry 5015 (class 2604 OID 45895)
-- Name: user_wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wallet ALTER COLUMN id SET DEFAULT nextval('public.user_wallet_id_seq'::regclass);


--
-- TOC entry 5354 (class 0 OID 45300)
-- Dependencies: 236
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, tasker_id, service_id, address_name, status, notes, created_at, updated_at, cancellation_reason, cancelled_by, is_recurring, recurring_pattern, house_number, total_price, completed_at, latitude, longitude, payment_status, task_details, package_id, scheduled_start, scheduled_end, duration_minutes) FROM stdin;
44	23	\N	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-05-13 10:48:42.644832	2025-05-27 09:12:58.245311	\N	completed	f	\N	\N	250000	2025-05-29 08:41:38.718364	10.60429920	107.06293899	paid	{"course": "5", "people": "4", "courses": ["Gà xào", "Bò nướng", "Lẩu thái", "Gỏi tai heo"]}	11	2025-05-30 09:00:00	2025-05-30 12:00:00	180
24	23	\N	20	643 Cách Mạng Tháng 8, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-17 09:34:30.41599	2025-05-27 09:12:58.368726	\N	completed	\N	\N	\N	140000	2025-05-17 09:34:30.415	10.60519925	107.06461625	paid	{"workload": "2 rooms - 55m2"}	2	2025-05-18 07:00:00	2025-05-18 09:00:00	120
22	23	\N	20	Đai Ly Gas QUYẾT, Đ. Trường Chinh/67 Tx, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-14 11:43:58.556794	2025-05-27 09:12:58.371726	\N	completed	\N	\N	\N	220000	2025-05-14 11:43:58.556	10.59726651	107.05881348	unpaid	{"workload": "4 rooms - 105m2"}	4	2025-05-16 07:00:00	2025-05-16 11:00:00	240
21	23	\N	20	Tuấn Anh 38 barbershop, 148, đường Trường Chinh, khu phố Vạn Hạnh, p Phú Mỹ, Bà Rịa Vũng Tàu	completed	\N	2025-05-13 11:13:04.402118	2025-05-27 09:12:58.378055	\N	completed	\N	\N	\N	140000	2025-05-13 11:13:04.402	10.59693531	107.06100192	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-05-15 11:00:00	2025-05-15 13:00:00	120
20	23	\N	20	Lotus Resort, Ấp Vạn Hạnh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	completed	\N	2025-05-13 10:59:41.695219	2025-05-27 09:12:58.382657	\N	completed	\N	\N	\N	140000	2025-05-13 10:59:41.695	10.59286157	107.06163952	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-05-14 10:55:00	2025-05-14 12:55:00	120
18	23	\N	20	Trường tiểu học Quang Trung, Đường Tôn Thất Tùng, Thị xã, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-13 10:34:18.6386	2025-05-27 09:12:58.385563	\N	completed	\N	\N	\N	140000	2025-05-13 10:34:18.616	\N	\N	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-05-15 10:30:00	2025-05-15 12:30:00	120
45	23	\N	20	126 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	pending	\N	2025-05-30 00:03:24.334614	2025-05-30 00:03:24.334614	\N	completed	\N	\N	\N	140000	2025-05-30 00:03:24.317	10.59682081	107.06220968	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-01 14:00:00	2025-06-01 16:00:00	120
53	23	32	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 54	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	\N	2025-07-02 12:00:00	2025-07-02 16:00:00	240
55	23	32	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 27	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	\N	2025-06-09 16:00:00	2025-06-09 20:00:00	240
57	23	34	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 54	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-22 08:00:00	2025-06-22 11:00:00	180
155	23	33	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 4	165000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-05 11:00:00	2025-07-05 14:00:00	180
156	23	30	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 94	165000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-18 09:00:00	2025-06-18 12:00:00	180
157	23	38	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 3	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-24 13:00:00	2025-06-24 16:00:00	180
158	23	33	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 82	140000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-30 16:00:00	2025-06-30 18:00:00	120
30	23	\N	20	Nhà nghỉ Hoàng Nam, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-17 11:22:57.65165	2025-05-27 09:12:58.386606	\N	completed	\N	\N	\N	140000	2025-05-17 11:22:57.651	10.59195159	107.06046017	paid	{"workload": "2 rooms - 55m2"}	2	2025-05-20 07:00:00	2025-05-20 09:00:00	120
43	23	\N	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-05-27 11:03:20.079885	2025-05-27 11:03:20.079885	\N	completed	\N	\N	\N	180000	2025-05-27 11:03:20.079	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-05-28 08:00:00	2025-05-31 11:00:00	180
46	23	\N	20	Mốc Xì Koi farm & Coffee, Đường Lê Lợi, khu ĐTM, Phú Mỹ, Bà Rịa - Vũng Tàu	pending	\N	2025-05-30 00:06:11.281845	2025-05-30 00:06:11.281845	\N	completed	\N	\N	\N	180000	2025-05-30 00:06:11.281	10.59403502	107.05765120	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-03 08:00:00	2025-06-03 11:00:00	180
47	23	30	20	Mốc Xì Koi farm & Coffee, Đường Lê Lợi, khu ĐTM, Phú Mỹ, Bà Rịa - Vũng Tàu	assigned	\N	2025-05-30 00:06:11.281845	2025-06-03 16:21:48.679851	\N	completed	f	\N	\N	180000	2025-05-30 00:06:11.281	10.59403502	107.05765120	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-04 08:00:00	2025-06-04 11:00:00	180
54	23	31	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 81	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "2", "courses": ["Cá kho", "Lẩu thái", "Gỏi tai heo", "Bò nướng"]}	11	2025-06-12 16:00:00	2025-06-12 19:00:00	180
56	23	31	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 75	255000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Cá kho", "Bò nướng", "Lẩu thái", "Gỏi tai heo"]}	10	2025-07-04 08:00:00	2025-07-04 10:00:00	120
58	23	39	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 11	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Bò nướng", "Lẩu thái"]}	9	2025-06-28 14:00:00	2025-06-28 18:00:00	240
19	23	\N	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-13 10:48:42.644832	2025-05-27 09:12:58.245311	\N	completed	\N	\N	\N	140000	2025-05-13 10:48:42.644	\N	\N	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-05-15 10:50:00	2025-05-15 12:50:00	120
142	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 83	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-17 08:00:00	2025-06-17 12:00:00	240
102	23	35	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.742243	\N	completed	f	\N	House 16	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-17 17:00:00	2025-06-17 19:00:00	120
50	23	31	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.795376	2025-06-08 11:01:01.795376	\N	completed	f	\N	House 97	140000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	\N	2025-06-30 09:00:00	2025-06-30 11:00:00	120
64	23	32	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 60	140000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-27 18:00:00	2025-06-27 21:00:00	180
66	23	31	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 15	140000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-04 14:00:00	2025-07-04 16:00:00	120
80	23	38	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 41	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Gỏi tai heo", "Lẩu thái"]}	10	2025-06-17 08:00:00	2025-06-17 11:00:00	180
65	23	38	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-24 22:28:41.811041	\N	completed	f	\N	House 3	180000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-13 10:00:00	2025-06-13 13:00:00	180
63	23	34	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 30	140000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-02 08:00:00	2025-07-02 12:00:00	240
68	23	38	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 70	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Cá kho"]}	9	2025-07-05 15:00:00	2025-07-05 19:00:00	240
69	23	33	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 15	165000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "2", "courses": ["Gỏi tai heo", "Gà xào", "Bò nướng", "Lẩu thái"]}	8	2025-06-16 12:00:00	2025-06-16 14:00:00	120
70	23	34	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 99	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Bò nướng", "Gỏi tai heo", "Lẩu thái", "Gà xào"]}	11	2025-06-27 15:00:00	2025-06-27 17:00:00	120
71	23	38	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 97	140000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-02 13:00:00	2025-07-02 15:00:00	120
72	23	31	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 66	180000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 08:00:00	2025-07-04 12:00:00	240
74	23	31	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 1	220000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 16:00:00	2025-06-10 20:00:00	240
75	23	37	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 53	255000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	10	2025-06-13 10:00:00	2025-06-13 14:00:00	240
76	23	33	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 48	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Lẩu thái", "Gà xào", "Cá kho"]}	11	2025-07-06 14:00:00	2025-07-06 18:00:00	240
77	23	37	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 85	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Cá kho", "Gỏi tai heo"]}	11	2025-06-14 10:00:00	2025-06-14 12:00:00	120
78	23	33	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 78	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-13 14:00:00	2025-06-13 18:00:00	240
79	23	34	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 34	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-09 16:00:00	2025-07-09 18:00:00	120
82	23	37	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 20	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-27 15:00:00	2025-06-27 18:00:00	180
83	23	34	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 34	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-26 09:00:00	2025-06-26 11:00:00	120
84	23	38	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 6	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-01 18:00:00	2025-07-01 22:00:00	240
81	23	31	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-24 22:28:41.84437	\N	completed	f	\N	House 48	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-23 08:00:00	2025-06-23 11:00:00	180
60	23	38	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 29	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	\N	2025-06-23 08:00:00	2025-06-23 12:00:00	240
92	23	35	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 20	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-26 16:00:00	2025-06-26 20:00:00	240
108	23	37	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 94	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-06 14:00:00	2025-07-06 17:00:00	180
109	23	37	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 63	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-29 16:00:00	2025-06-29 19:00:00	180
111	23	35	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 47	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Bò nướng", "Lẩu thái", "Gà xào"]}	8	2025-06-18 11:00:00	2025-06-18 13:00:00	120
113	23	37	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 33	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Cá kho", "Gỏi tai heo", "Lẩu thái", "Gà xào"]}	10	2025-07-01 18:00:00	2025-07-01 20:00:00	120
115	23	32	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 2	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Bò nướng", "Gỏi tai heo", "Gà xào"]}	9	2025-06-26 09:00:00	2025-06-26 11:00:00	120
154	23	37	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 18	140000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-29 10:00:00	2025-06-29 12:00:00	120
160	23	38	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 29	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-29 18:00:00	2025-06-29 20:00:00	120
41	23	30	20	Nhà nghỉ Hoàng Nam, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-05-17 11:22:57.65165	2025-05-28 09:37:09.127951	test	tasker	f	\N	\N	140000	2025-05-28 22:05:09.413265	10.59195159	107.06046017	paid	{"workload": "2 rooms - 55m2"}	2	2025-05-28 07:00:00	2025-05-28 09:00:00	120
91	23	32	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 91	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "2", "courses": ["Gỏi tai heo", "Lẩu thái"]}	9	2025-06-28 08:00:00	2025-06-28 12:00:00	240
94	23	35	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 48	295000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Gỏi tai heo", "Lẩu thái"]}	11	2025-06-26 10:00:00	2025-06-26 13:00:00	180
96	23	32	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 95	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Cá kho", "Lẩu thái", "Gỏi tai heo", "Gà xào"]}	10	2025-07-09 16:00:00	2025-07-09 18:00:00	120
98	23	35	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 99	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-05 14:00:00	2025-07-05 16:00:00	120
99	23	33	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 57	295000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-04 15:00:00	2025-07-04 19:00:00	240
107	23	37	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 5	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-27 13:00:00	2025-06-27 17:00:00	240
112	23	33	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 41	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-15 14:00:00	2025-06-15 16:00:00	120
116	23	33	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 13	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Cá kho", "Gỏi tai heo", "Bò nướng"]}	8	2025-06-12 17:00:00	2025-06-12 20:00:00	180
147	23	35	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 52	220000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-06 08:00:00	2025-07-06 10:00:00	120
151	23	33	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.881797	\N	completed	f	\N	House 22	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-23 11:00:00	2025-06-23 13:00:00	120
246	23	36	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 83	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Cá kho", "Lẩu thái", "Gà xào"]}	10	2025-06-28 14:00:00	2025-06-28 17:00:00	180
248	23	30	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 74	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Bò nướng", "Gỏi tai heo", "Cá kho"]}	10	2025-06-26 09:00:00	2025-06-26 13:00:00	240
90	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 40	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-08 10:00:00	2025-07-08 12:00:00	120
153	23	32	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.90007	\N	completed	f	\N	House 33	165000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-24 12:00:00	2025-06-24 16:00:00	240
132	23	35	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 12	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-15 10:00:00	2025-06-15 14:00:00	240
134	23	39	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 47	220000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 17:00:00	2025-06-10 21:00:00	240
141	23	36	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 5	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Bò nướng", "Cá kho"]}	8	2025-06-25 16:00:00	2025-06-25 20:00:00	240
210	23	33	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 72	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Gà xào", "Lẩu thái"]}	9	2025-07-07 08:00:00	2025-07-07 10:00:00	120
131	23	36	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 61	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-30 12:00:00	2025-06-30 16:00:00	240
133	23	33	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 11	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-22 17:00:00	2025-06-22 20:00:00	180
136	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 87	180000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-08 09:00:00	2025-07-08 12:00:00	180
137	23	38	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 75	295000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Gỏi tai heo", "Cá kho"]}	11	2025-07-04 18:00:00	2025-07-04 20:00:00	120
138	23	32	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 79	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-20 13:00:00	2025-06-20 16:00:00	180
139	23	37	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 81	180000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-16 08:00:00	2025-06-16 11:00:00	180
144	23	39	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 64	220000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-07 18:00:00	2025-07-07 22:00:00	240
146	23	36	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 83	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Gỏi tai heo", "Bò nướng"]}	8	2025-07-08 13:00:00	2025-07-08 17:00:00	240
162	23	37	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 10	140000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-21 15:00:00	2025-06-21 19:00:00	240
205	23	36	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.926071	\N	completed	f	\N	House 54	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-11 18:00:00	2025-06-11 22:00:00	240
207	23	34	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 60	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Gỏi tai heo", "Gà xào", "Bò nướng"]}	9	2025-07-09 10:00:00	2025-07-09 13:00:00	180
208	23	37	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 22	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 15:00:00	2025-07-08 17:00:00	120
251	23	30	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 89	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Gà xào", "Lẩu thái", "Bò nướng", "Cá kho"]}	11	2025-07-03 13:00:00	2025-07-03 16:00:00	180
252	23	36	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 75	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-30 16:00:00	2025-06-30 19:00:00	180
253	23	30	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 66	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-03 12:00:00	2025-07-03 16:00:00	240
367	23	30	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 29	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-28 15:00:00	2025-06-28 17:00:00	120
119	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 21	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-07 11:00:00	2025-07-07 14:00:00	180
206	23	38	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.933069	\N	completed	f	\N	House 98	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-22 10:00:00	2025-06-22 12:00:00	120
209	23	31	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.940711	\N	completed	f	\N	House 24	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 18:00:00	2025-06-18 21:00:00	180
89	23	33	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 72	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-23 11:00:00	2025-06-23 14:00:00	180
117	23	37	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 100	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-03 12:00:00	2025-07-03 16:00:00	240
177	23	31	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 63	210000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Lẩu thái", "Cá kho", "Bò nướng", "Gà xào"]}	9	2025-06-27 14:00:00	2025-06-27 18:00:00	240
179	23	39	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 9	210000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-25 09:00:00	2025-06-25 13:00:00	240
182	23	32	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 29	210000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-04 09:00:00	2025-07-04 11:00:00	120
183	23	35	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 23	220000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-11 18:00:00	2025-06-11 21:00:00	180
181	23	38	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 50	165000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Lẩu thái", "Bò nướng", "Gỏi tai heo"]}	8	2025-06-30 11:00:00	2025-06-30 14:00:00	180
363	23	32	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 80	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-09 16:00:00	2025-06-09 19:00:00	180
163	23	33	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 40	165000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Lẩu thái", "Bò nướng", "Gỏi tai heo"]}	8	2025-06-17 16:00:00	2025-06-17 19:00:00	180
164	23	35	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 53	295000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Lẩu thái", "Cá kho", "Gỏi tai heo"]}	11	2025-06-14 09:00:00	2025-06-14 13:00:00	240
166	23	34	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 62	255000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Lẩu thái", "Bò nướng"]}	10	2025-06-21 08:00:00	2025-06-21 11:00:00	180
168	23	35	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.879878	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 42	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-18 08:00:00	2025-06-18 12:00:00	240
169	23	35	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 53	295000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Cá kho", "Bò nướng", "Gỏi tai heo"]}	11	2025-06-21 16:00:00	2025-06-21 19:00:00	180
171	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 86	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-03 13:00:00	2025-07-03 16:00:00	180
173	23	34	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 25	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-09 13:00:00	2025-06-09 15:00:00	120
174	23	30	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 81	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-22 14:00:00	2025-06-22 17:00:00	180
176	23	34	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 15	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-02 10:00:00	2025-07-02 12:00:00	120
178	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 8	210000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-21 09:00:00	2025-06-21 12:00:00	180
95	23	38	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.971994	\N	completed	f	\N	House 48	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Cá kho", "Bò nướng", "Lẩu thái"]}	9	2025-06-21 08:00:00	2025-06-21 12:00:00	240
326	23	38	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.977599	\N	completed	f	\N	House 41	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-20 13:00:00	2025-06-20 15:00:00	120
327	23	35	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 4	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-29 08:00:00	2025-06-29 10:00:00	120
328	23	31	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 87	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 13:00:00	2025-07-08 17:00:00	240
364	23	30	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 3	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Cá kho", "Gỏi tai heo", "Bò nướng", "Gà xào"]}	9	2025-06-13 17:00:00	2025-06-13 19:00:00	120
59	23	32	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 100	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-20 10:00:00	2025-06-20 13:00:00	180
67	23	38	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 12	165000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Bò nướng", "Gỏi tai heo", "Lẩu thái"]}	8	2025-06-12 13:00:00	2025-06-12 15:00:00	120
189	23	37	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 55	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Cá kho", "Lẩu thái"]}	9	2025-06-30 13:00:00	2025-06-30 16:00:00	180
190	23	31	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 44	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Gà xào", "Lẩu thái", "Cá kho"]}	9	2025-06-13 17:00:00	2025-06-13 19:00:00	120
194	23	37	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 51	180000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-05 11:00:00	2025-07-05 13:00:00	120
196	23	31	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 4	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-20 09:00:00	2025-06-20 12:00:00	180
198	23	34	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 14	255000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Cá kho", "Gà xào", "Lẩu thái"]}	10	2025-07-06 14:00:00	2025-07-06 17:00:00	180
200	23	30	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.983946	\N	completed	f	\N	House 72	295000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Gỏi tai heo", "Bò nướng", "Cá kho"]}	11	2025-06-19 16:00:00	2025-06-19 19:00:00	180
211	23	35	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 22	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-02 11:00:00	2025-07-02 14:00:00	180
552	23	38	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 49	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 11:00:00	2025-06-30 15:00:00	240
553	23	39	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 27	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-27 09:00:00	2025-06-27 13:00:00	240
187	23	34	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 20	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-05 14:00:00	2025-07-05 16:00:00	120
191	23	36	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 100	165000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Gà xào", "Lẩu thái", "Cá kho"]}	8	2025-07-06 17:00:00	2025-07-06 20:00:00	180
192	23	39	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 59	140000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-21 10:00:00	2025-06-21 14:00:00	240
193	23	30	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 42	140000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-09 09:00:00	2025-07-09 11:00:00	120
197	23	38	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 25	295000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "7", "courses": ["Cá kho", "Bò nướng", "Gà xào"]}	11	2025-06-14 15:00:00	2025-06-14 18:00:00	180
199	23	31	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 16	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-16 16:00:00	2025-06-16 19:00:00	180
212	23	37	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 41	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Lẩu thái", "Gà xào", "Cá kho", "Bò nướng"]}	9	2025-06-28 16:00:00	2025-06-28 18:00:00	120
213	23	34	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 63	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gỏi tai heo", "Cá kho", "Gà xào", "Lẩu thái"]}	9	2025-07-01 14:00:00	2025-07-01 18:00:00	240
371	23	37	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 96	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Lẩu thái", "Gỏi tai heo"]}	10	2025-06-27 08:00:00	2025-06-27 11:00:00	180
374	23	35	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 79	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-07 10:00:00	2025-07-07 12:00:00	120
549	23	37	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 76	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-28 14:00:00	2025-06-28 18:00:00	240
186	23	38	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 56	210000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-12 16:00:00	2025-06-12 20:00:00	240
222	23	35	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 72	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "4", "courses": ["Lẩu thái", "Gỏi tai heo"]}	11	2025-06-25 11:00:00	2025-06-25 14:00:00	180
234	23	37	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 56	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 15:00:00	2025-07-04 18:00:00	180
235	23	39	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 88	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 15:00:00	2025-06-20 18:00:00	180
236	23	35	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 31	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Gỏi tai heo", "Bò nướng", "Cá kho"]}	9	2025-06-10 12:00:00	2025-06-10 15:00:00	180
240	23	36	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 55	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-22 18:00:00	2025-06-22 21:00:00	180
241	23	37	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 98	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-11 15:00:00	2025-06-11 18:00:00	180
242	23	30	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 96	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-23 17:00:00	2025-06-23 19:00:00	120
218	23	34	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 78	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 17:00:00	2025-07-03 20:00:00	180
223	23	30	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 60	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-09 18:00:00	2025-07-09 21:00:00	180
224	23	39	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 92	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Gà xào", "Cá kho", "Gỏi tai heo", "Bò nướng"]}	10	2025-07-03 14:00:00	2025-07-03 17:00:00	180
225	23	32	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 45	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Gà xào", "Cá kho", "Bò nướng", "Gỏi tai heo"]}	9	2025-07-08 09:00:00	2025-07-08 12:00:00	180
226	23	38	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 71	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-30 09:00:00	2025-06-30 11:00:00	120
227	23	34	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 70	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "7", "courses": ["Gà xào", "Bò nướng"]}	9	2025-07-03 08:00:00	2025-07-03 10:00:00	120
233	23	31	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 33	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-28 12:00:00	2025-06-28 16:00:00	240
237	23	39	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 30	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Gà xào", "Gỏi tai heo", "Bò nướng"]}	8	2025-07-04 17:00:00	2025-07-04 21:00:00	240
238	23	36	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 48	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-02 17:00:00	2025-07-02 21:00:00	240
239	23	34	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 72	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 17:00:00	2025-07-05 20:00:00	180
542	23	31	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 56	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-22 18:00:00	2025-06-22 22:00:00	240
554	23	35	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 80	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Cá kho", "Gà xào", "Gỏi tai heo"]}	9	2025-06-29 16:00:00	2025-06-29 18:00:00	120
556	23	30	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 38	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Gà xào", "Bò nướng", "Cá kho", "Lẩu thái"]}	10	2025-07-08 17:00:00	2025-07-08 19:00:00	120
633	23	33	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 41	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-29 16:00:00	2025-06-29 18:00:00	120
634	23	36	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 62	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 15:00:00	2025-06-30 17:00:00	120
243	23	33	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.026107	\N	completed	f	\N	House 92	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 17:00:00	2025-06-20 20:00:00	180
244	23	37	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.038557	\N	completed	f	\N	House 96	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-15 14:00:00	2025-06-15 18:00:00	240
257	23	37	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 19	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Lẩu thái", "Cá kho", "Bò nướng"]}	11	2025-07-09 17:00:00	2025-07-09 21:00:00	240
268	23	31	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 54	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-27 15:00:00	2025-06-27 17:00:00	120
275	23	30	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 54	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 15:00:00	2025-06-14 18:00:00	180
247	23	39	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 15	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 18:00:00	2025-06-29 20:00:00	120
254	23	30	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 29	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-25 09:00:00	2025-06-25 13:00:00	240
255	23	32	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 89	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Gà xào", "Bò nướng", "Cá kho"]}	9	2025-07-07 09:00:00	2025-07-07 13:00:00	240
256	23	33	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 74	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-27 10:00:00	2025-06-27 14:00:00	240
258	23	35	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 99	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Lẩu thái", "Gỏi tai heo", "Gà xào"]}	10	2025-06-29 14:00:00	2025-06-29 16:00:00	120
259	23	35	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 82	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-28 11:00:00	2025-06-28 15:00:00	240
260	23	33	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 79	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-13 08:00:00	2025-06-13 11:00:00	180
264	23	33	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 49	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 10:00:00	2025-07-04 13:00:00	180
266	23	35	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 39	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-21 18:00:00	2025-06-21 21:00:00	180
267	23	34	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 38	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-28 08:00:00	2025-06-28 10:00:00	120
269	23	32	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 63	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Gà xào", "Bò nướng"]}	10	2025-06-13 15:00:00	2025-06-13 18:00:00	180
270	23	35	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 5	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-15 11:00:00	2025-06-15 14:00:00	180
271	23	39	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 61	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Cá kho", "Gỏi tai heo"]}	9	2025-06-21 11:00:00	2025-06-21 15:00:00	240
272	23	39	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 30	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Cá kho", "Lẩu thái", "Gỏi tai heo"]}	11	2025-06-19 13:00:00	2025-06-19 15:00:00	120
273	23	35	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 84	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 17:00:00	2025-06-19 20:00:00	180
274	23	31	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 48	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-26 09:00:00	2025-06-26 12:00:00	180
330	23	38	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 45	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Lẩu thái", "Gà xào", "Gỏi tai heo"]}	10	2025-07-02 08:00:00	2025-07-02 10:00:00	120
286	23	31	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 49	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Gà xào", "Gỏi tai heo", "Lẩu thái"]}	9	2025-06-13 13:00:00	2025-06-13 15:00:00	120
290	23	35	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 9	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-11 09:00:00	2025-06-11 13:00:00	240
292	23	31	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 22	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 18:00:00	2025-06-19 22:00:00	240
293	23	34	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 31	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-28 12:00:00	2025-06-28 16:00:00	240
297	23	37	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 94	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-04 18:00:00	2025-07-04 22:00:00	240
277	23	33	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 98	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-18 16:00:00	2025-06-18 20:00:00	240
278	23	35	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 50	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Lẩu thái", "Cá kho", "Gỏi tai heo", "Bò nướng"]}	11	2025-06-10 17:00:00	2025-06-10 19:00:00	120
279	23	30	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 97	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Cá kho", "Gỏi tai heo"]}	11	2025-06-11 15:00:00	2025-06-11 18:00:00	180
281	23	33	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 13	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Gà xào", "Bò nướng"]}	11	2025-06-10 10:00:00	2025-06-10 12:00:00	120
282	23	36	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 12	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-06 10:00:00	2025-07-06 14:00:00	240
283	23	37	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 99	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Gỏi tai heo", "Bò nướng", "Lẩu thái", "Cá kho"]}	11	2025-07-05 08:00:00	2025-07-05 10:00:00	120
285	23	35	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 44	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-15 15:00:00	2025-06-15 18:00:00	180
287	23	32	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 60	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Cá kho", "Lẩu thái", "Bò nướng"]}	10	2025-06-14 12:00:00	2025-06-14 16:00:00	240
288	23	37	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 5	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Gà xào", "Gỏi tai heo", "Lẩu thái", "Cá kho"]}	9	2025-06-30 17:00:00	2025-06-30 20:00:00	180
289	23	32	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 99	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 12:00:00	2025-06-30 14:00:00	120
291	23	32	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 93	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 08:00:00	2025-07-04 10:00:00	120
294	23	37	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 55	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Bò nướng", "Lẩu thái", "Cá kho", "Gỏi tai heo"]}	9	2025-06-09 14:00:00	2025-06-09 17:00:00	180
296	23	37	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 27	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 13:00:00	2025-07-04 16:00:00	180
298	23	36	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 4	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Gỏi tai heo", "Bò nướng", "Gà xào"]}	10	2025-06-13 10:00:00	2025-06-13 14:00:00	240
299	23	32	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 31	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "2", "courses": ["Gà xào", "Bò nướng", "Cá kho", "Lẩu thái"]}	9	2025-06-22 17:00:00	2025-06-22 20:00:00	180
302	23	34	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 17	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Bò nướng", "Gà xào"]}	9	2025-07-03 14:00:00	2025-07-03 18:00:00	240
303	23	35	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 40	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Bò nướng", "Cá kho", "Gỏi tai heo", "Lẩu thái"]}	8	2025-06-23 14:00:00	2025-06-23 18:00:00	240
331	23	39	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 15	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Gỏi tai heo"]}	9	2025-06-25 10:00:00	2025-06-25 13:00:00	180
502	23	35	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 85	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 16:00:00	2025-07-05 18:00:00	120
501	23	34	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.065486	\N	completed	f	\N	House 67	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-23 10:00:00	2025-06-23 13:00:00	180
503	23	32	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.071485	\N	completed	f	\N	House 78	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-24 08:00:00	2025-06-24 10:00:00	120
261	23	35	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 21	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 13:00:00	2025-07-04 17:00:00	240
262	23	37	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 71	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-26 09:00:00	2025-06-26 12:00:00	180
304	23	33	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 25	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Bò nướng", "Cá kho", "Lẩu thái"]}	10	2025-06-13 15:00:00	2025-06-13 18:00:00	180
308	23	39	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 22	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 15:00:00	2025-07-03 18:00:00	180
309	23	36	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 99	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Gỏi tai heo", "Gà xào", "Lẩu thái"]}	8	2025-07-09 18:00:00	2025-07-09 21:00:00	180
317	23	34	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 22	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Gà xào", "Cá kho", "Lẩu thái", "Gỏi tai heo"]}	11	2025-06-14 10:00:00	2025-06-14 14:00:00	240
332	23	32	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 8	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-20 12:00:00	2025-06-20 14:00:00	120
648	23	36	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 41	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-09 17:00:00	2025-07-09 19:00:00	120
167	23	35	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 32	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-22 08:00:00	2025-06-22 11:00:00	180
321	23	32	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.077067	\N	completed	f	\N	House 44	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-16 16:00:00	2025-06-16 19:00:00	180
263	23	33	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 43	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-16 08:00:00	2025-06-16 10:00:00	120
305	23	34	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 87	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-08 15:00:00	2025-07-08 18:00:00	180
306	23	34	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 73	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-08 09:00:00	2025-07-08 11:00:00	120
307	23	37	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 18	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-27 17:00:00	2025-06-27 19:00:00	120
310	23	32	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 12	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-18 12:00:00	2025-06-18 15:00:00	180
311	23	38	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 65	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-14 15:00:00	2025-06-14 19:00:00	240
312	23	37	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 11	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "7", "courses": ["Gỏi tai heo", "Gà xào", "Cá kho", "Lẩu thái"]}	9	2025-06-15 11:00:00	2025-06-15 15:00:00	240
313	23	36	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 68	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-29 15:00:00	2025-06-29 18:00:00	180
314	23	34	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 54	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-21 13:00:00	2025-06-21 15:00:00	120
316	23	30	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 56	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 12:00:00	2025-06-17 16:00:00	240
319	23	33	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 35	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Cá kho", "Gỏi tai heo", "Gà xào"]}	9	2025-07-02 15:00:00	2025-07-02 19:00:00	240
323	23	37	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 68	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-08 10:00:00	2025-07-08 14:00:00	240
324	23	36	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 59	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 09:00:00	2025-07-05 12:00:00	180
333	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 74	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-21 11:00:00	2025-06-21 13:00:00	120
636	23	31	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 13	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-09 11:00:00	2025-07-09 13:00:00	120
637	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 72	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-28 16:00:00	2025-06-28 19:00:00	180
646	23	33	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 59	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 15:00:00	2025-06-20 17:00:00	120
159	23	38	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 61	210000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Cá kho", "Bò nướng"]}	9	2025-06-25 17:00:00	2025-06-25 20:00:00	180
344	23	30	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 21	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-07 10:00:00	2025-07-07 12:00:00	120
349	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 11	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 16:00:00	2025-07-08 18:00:00	120
356	23	34	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 20	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Bò nướng", "Cá kho", "Gà xào", "Lẩu thái"]}	11	2025-06-29 17:00:00	2025-06-29 21:00:00	240
357	23	30	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 58	255000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-09 13:00:00	2025-07-09 15:00:00	120
358	23	38	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 18	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-20 17:00:00	2025-06-20 19:00:00	120
361	23	37	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 56	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 12:00:00	2025-07-03 16:00:00	240
649	23	39	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 52	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-22 09:00:00	2025-06-22 12:00:00	180
335	23	39	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 93	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-12 16:00:00	2025-06-12 18:00:00	120
342	23	31	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 91	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Gỏi tai heo", "Bò nướng"]}	8	2025-06-11 12:00:00	2025-06-11 15:00:00	180
343	23	31	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 52	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-02 18:00:00	2025-07-02 20:00:00	120
346	23	35	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 34	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Bò nướng", "Gỏi tai heo"]}	10	2025-06-30 08:00:00	2025-06-30 10:00:00	120
347	23	34	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 14	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-27 09:00:00	2025-06-27 12:00:00	180
348	23	35	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 64	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Lẩu thái", "Gà xào", "Gỏi tai heo", "Bò nướng"]}	8	2025-06-18 16:00:00	2025-06-18 18:00:00	120
350	23	32	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 39	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-01 14:00:00	2025-07-01 16:00:00	120
351	23	38	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 24	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-09 09:00:00	2025-07-09 11:00:00	120
354	23	31	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 42	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 09:00:00	2025-06-09 12:00:00	180
355	23	32	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 60	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Bò nướng", "Cá kho", "Gà xào", "Lẩu thái"]}	9	2025-06-22 10:00:00	2025-06-22 12:00:00	120
359	23	36	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 28	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Lẩu thái", "Cá kho", "Gỏi tai heo"]}	9	2025-06-27 14:00:00	2025-06-27 16:00:00	120
362	23	35	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 25	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-18 10:00:00	2025-06-18 13:00:00	180
504	23	31	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 48	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Cá kho", "Lẩu thái"]}	8	2025-06-27 15:00:00	2025-06-27 18:00:00	180
543	23	30	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 57	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-26 11:00:00	2025-06-26 15:00:00	240
544	23	35	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 20	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Cá kho", "Gà xào"]}	8	2025-07-05 18:00:00	2025-07-05 20:00:00	120
654	23	\N	20	Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-17 10:16:53.94503	2025-06-17 10:16:53.94503	\N	completed	\N	\N	\N	145000	2025-06-17 10:16:53.94503	10.59631494	107.06289214	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-06-20 00:00:00	2025-06-20 02:00:00	120
655	23	\N	20	Hoa Viên Tiệc Cưới Thạch Linh Trúc, Trần Hưng Đạo, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-17 10:18:48.117229	2025-06-17 10:18:48.117229	\N	completed	\N	\N	\N	180000	2025-06-17 10:18:48.117229	10.58804976	107.06357238	unpaid	{"workload": "3 rooms - 85m2"}	3	2025-06-19 00:00:00	2025-06-19 03:00:00	180
656	23	\N	20	Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-17 10:19:25.488703	2025-06-17 10:19:25.488703	\N	completed	\N	\N	\N	180000	2025-06-17 10:19:25.488674	10.59643224	107.06295261	unpaid	{"workload": "3 rooms - 85m2"}	3	2025-06-20 00:00:00	2025-06-20 03:00:00	180
148	23	36	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.90807	\N	completed	f	\N	House 15	210000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Cá kho", "Bò nướng", "Lẩu thái"]}	9	2025-06-11 16:00:00	2025-06-11 18:00:00	120
149	23	33	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.914069	\N	completed	f	\N	House 88	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-20 08:00:00	2025-06-20 12:00:00	240
245	23	30	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.919069	\N	completed	f	\N	House 71	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-18 18:00:00	2025-06-18 21:00:00	180
380	23	31	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 24	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 11:00:00	2025-06-18 14:00:00	180
381	23	34	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 27	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-08 18:00:00	2025-07-08 20:00:00	120
383	23	33	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 60	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 10:00:00	2025-06-30 12:00:00	120
384	23	39	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 89	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Lẩu thái", "Gỏi tai heo"]}	10	2025-06-24 18:00:00	2025-06-24 21:00:00	180
387	23	38	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 78	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 14:00:00	2025-07-03 18:00:00	240
388	23	35	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 88	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 18:00:00	2025-06-20 21:00:00	180
389	23	38	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 11	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gỏi tai heo", "Bò nướng", "Gà xào"]}	11	2025-07-06 18:00:00	2025-07-06 21:00:00	180
93	23	37	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 78	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-18 14:00:00	2025-06-18 17:00:00	180
118	23	39	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 86	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-28 17:00:00	2025-06-28 19:00:00	120
126	23	36	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 64	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-06 17:00:00	2025-07-06 20:00:00	180
127	23	35	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 74	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-06 16:00:00	2025-07-06 19:00:00	180
161	23	39	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 14	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-08 16:00:00	2025-07-08 19:00:00	180
185	23	31	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 43	210000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-15 08:00:00	2025-06-15 12:00:00	240
365	23	37	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.08856	\N	completed	f	\N	House 16	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Bò nướng", "Cá kho"]}	10	2025-06-11 11:00:00	2025-06-11 15:00:00	240
231	23	33	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 66	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 18:00:00	2025-06-30 20:00:00	120
284	23	39	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 57	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 14:00:00	2025-06-09 16:00:00	120
366	23	38	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 6	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-29 18:00:00	2025-06-29 20:00:00	120
376	23	37	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 3	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "4", "courses": ["Bò nướng", "Gà xào"]}	9	2025-07-01 16:00:00	2025-07-01 18:00:00	120
377	23	36	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 86	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Bò nướng", "Cá kho"]}	8	2025-06-15 16:00:00	2025-06-15 19:00:00	180
378	23	34	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 59	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-20 12:00:00	2025-06-20 15:00:00	180
379	23	34	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 87	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-21 17:00:00	2025-06-21 20:00:00	180
382	23	34	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 44	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 15:00:00	2025-07-06 18:00:00	180
386	23	38	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 20	140000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Gà xào", "Bò nướng"]}	11	2025-06-24 16:00:00	2025-06-24 18:00:00	120
391	23	39	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 25	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-18 13:00:00	2025-06-18 16:00:00	180
394	23	35	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 4	295000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-02 13:00:00	2025-07-02 16:00:00	180
424	23	32	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 14	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-16 12:00:00	2025-06-16 15:00:00	180
507	23	38	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.101568	\N	completed	f	\N	House 96	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 14:00:00	2025-06-18 18:00:00	240
396	23	30	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 24	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Bò nướng", "Gà xào"]}	11	2025-06-18 11:00:00	2025-06-18 13:00:00	120
399	23	36	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 33	295000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-29 16:00:00	2025-06-29 20:00:00	240
400	23	38	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 73	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-22 15:00:00	2025-06-22 19:00:00	240
404	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 30	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-14 13:00:00	2025-06-14 16:00:00	180
416	23	31	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 91	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 18:00:00	2025-06-17 22:00:00	240
417	23	31	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 8	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-01 13:00:00	2025-07-01 16:00:00	180
392	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 94	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-06 13:00:00	2025-07-06 17:00:00	240
395	23	39	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 69	295000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 18:00:00	2025-06-19 22:00:00	240
397	23	36	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 41	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-28 14:00:00	2025-06-28 18:00:00	240
398	23	38	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 95	295000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 14:00:00	2025-06-30 16:00:00	120
402	23	37	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 85	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-19 16:00:00	2025-06-19 19:00:00	180
403	23	36	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 12	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 09:00:00	2025-06-09 13:00:00	240
405	23	35	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 81	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Gỏi tai heo", "Bò nướng", "Cá kho"]}	10	2025-07-02 14:00:00	2025-07-02 17:00:00	180
406	23	33	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 80	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-15 12:00:00	2025-06-15 14:00:00	120
407	23	38	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 42	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 13:00:00	2025-06-10 16:00:00	180
408	23	34	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 9	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Gà xào", "Cá kho", "Bò nướng"]}	8	2025-06-27 11:00:00	2025-06-27 14:00:00	180
409	23	32	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 8	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-26 17:00:00	2025-06-26 20:00:00	180
410	23	39	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 47	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-29 09:00:00	2025-06-29 11:00:00	120
411	23	33	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 87	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Lẩu thái", "Gà xào"]}	8	2025-06-17 09:00:00	2025-06-17 11:00:00	120
412	23	32	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 18	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Lẩu thái", "Cá kho", "Bò nướng"]}	11	2025-07-03 17:00:00	2025-07-03 19:00:00	120
413	23	35	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 27	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-20 08:00:00	2025-06-20 11:00:00	180
414	23	31	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 79	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Gỏi tai heo", "Bò nướng", "Lẩu thái"]}	10	2025-06-22 14:00:00	2025-06-22 18:00:00	240
415	23	38	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 49	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 18:00:00	2025-06-09 20:00:00	120
418	23	37	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 56	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Gà xào", "Gỏi tai heo", "Bò nướng", "Lẩu thái"]}	8	2025-07-08 16:00:00	2025-07-08 19:00:00	180
419	23	30	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883873	2025-06-08 22:50:13.883873	\N	completed	f	\N	House 92	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Bò nướng", "Gỏi tai heo", "Gà xào", "Lẩu thái"]}	10	2025-06-13 17:00:00	2025-06-13 20:00:00	180
584	23	32	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 19	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Lẩu thái", "Gỏi tai heo", "Gà xào"]}	8	2025-07-02 11:00:00	2025-07-02 13:00:00	120
585	23	34	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 77	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-01 09:00:00	2025-07-01 12:00:00	180
427	23	33	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 14	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 17:00:00	2025-07-03 19:00:00	120
428	23	35	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 58	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-09 08:00:00	2025-07-09 12:00:00	240
431	23	33	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 22	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-07 17:00:00	2025-07-07 19:00:00	120
433	23	35	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 32	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 11:00:00	2025-06-17 13:00:00	120
434	23	30	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 63	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Cá kho", "Lẩu thái"]}	11	2025-06-30 11:00:00	2025-06-30 14:00:00	180
439	23	38	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 10	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-19 14:00:00	2025-06-19 17:00:00	180
444	23	34	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 6	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Lẩu thái", "Bò nướng"]}	10	2025-07-07 15:00:00	2025-07-07 18:00:00	180
451	23	33	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 92	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 12:00:00	2025-07-06 16:00:00	240
586	23	36	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 66	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-29 10:00:00	2025-06-29 12:00:00	120
587	23	39	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.113393	\N	completed	f	\N	House 87	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-14 12:00:00	2025-06-14 14:00:00	120
421	23	39	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 35	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Cá kho", "Lẩu thái"]}	8	2025-07-02 17:00:00	2025-07-02 19:00:00	120
422	23	31	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 2	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-12 17:00:00	2025-06-12 21:00:00	240
423	23	38	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 68	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Bò nướng"]}	8	2025-06-13 18:00:00	2025-06-13 21:00:00	180
425	23	31	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 10	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-23 11:00:00	2025-06-23 13:00:00	120
426	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 38	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 15:00:00	2025-07-05 18:00:00	180
429	23	35	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 30	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "2", "courses": ["Bò nướng", "Lẩu thái", "Gỏi tai heo"]}	8	2025-06-10 10:00:00	2025-06-10 12:00:00	120
430	23	39	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 81	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-23 08:00:00	2025-06-23 10:00:00	120
432	23	32	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 57	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 08:00:00	2025-06-17 10:00:00	120
436	23	30	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 14	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Gà xào", "Bò nướng", "Cá kho", "Gỏi tai heo"]}	8	2025-06-14 15:00:00	2025-06-14 19:00:00	240
437	23	33	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 90	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-03 11:00:00	2025-07-03 13:00:00	120
438	23	35	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 32	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 15:00:00	2025-06-19 18:00:00	180
440	23	39	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 9	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-18 14:00:00	2025-06-18 16:00:00	120
441	23	30	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 89	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 16:00:00	2025-06-17 19:00:00	180
442	23	39	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 98	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-21 16:00:00	2025-06-21 19:00:00	180
443	23	37	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 88	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-25 13:00:00	2025-06-25 15:00:00	120
447	23	38	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 88	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Cá kho", "Lẩu thái", "Gỏi tai heo"]}	8	2025-07-06 11:00:00	2025-07-06 15:00:00	240
448	23	39	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 43	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Gỏi tai heo", "Cá kho", "Bò nướng", "Lẩu thái"]}	9	2025-07-02 10:00:00	2025-07-02 12:00:00	120
449	23	31	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 75	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 12:00:00	2025-07-04 16:00:00	240
589	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 90	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 15:00:00	2025-06-29 18:00:00	180
457	23	33	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 48	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-20 18:00:00	2025-06-20 22:00:00	240
464	23	39	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 8	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Bò nướng", "Lẩu thái", "Gỏi tai heo", "Cá kho"]}	10	2025-06-25 14:00:00	2025-06-25 18:00:00	240
467	23	36	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 57	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Bò nướng", "Lẩu thái", "Cá kho"]}	11	2025-06-11 09:00:00	2025-06-11 12:00:00	180
469	23	30	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 87	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-10 09:00:00	2025-06-10 11:00:00	120
472	23	36	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 34	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-12 13:00:00	2025-06-12 16:00:00	180
473	23	38	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 80	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-29 12:00:00	2025-06-29 14:00:00	120
479	23	39	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 95	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-21 13:00:00	2025-06-21 17:00:00	240
481	23	30	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 41	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-09 12:00:00	2025-07-09 14:00:00	120
214	23	33	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 40	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	11	2025-06-18 12:00:00	2025-06-18 16:00:00	240
216	23	39	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 48	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Gà xào", "Gỏi tai heo", "Bò nướng", "Cá kho"]}	8	2025-06-10 11:00:00	2025-06-10 15:00:00	240
452	23	35	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 17	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gỏi tai heo", "Gà xào", "Cá kho", "Bò nướng"]}	9	2025-06-19 11:00:00	2025-06-19 14:00:00	180
453	23	32	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 60	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Cá kho", "Bò nướng"]}	9	2025-06-17 08:00:00	2025-06-17 10:00:00	120
454	23	36	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 78	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-10 09:00:00	2025-06-10 11:00:00	120
455	23	35	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 20	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-21 08:00:00	2025-06-21 11:00:00	180
458	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 9	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-03 14:00:00	2025-07-03 17:00:00	180
459	23	35	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 58	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-01 08:00:00	2025-07-01 11:00:00	180
460	23	34	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 17	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Gỏi tai heo", "Lẩu thái", "Cá kho"]}	8	2025-06-10 17:00:00	2025-06-10 21:00:00	240
461	23	32	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 93	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 12:00:00	2025-07-04 15:00:00	180
462	23	32	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 71	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 16:00:00	2025-06-10 18:00:00	120
463	23	38	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 8	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-12 14:00:00	2025-06-12 16:00:00	120
466	23	31	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 26	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 17:00:00	2025-07-08 20:00:00	180
468	23	30	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 69	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 11:00:00	2025-06-14 13:00:00	120
471	23	33	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 93	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 08:00:00	2025-07-05 12:00:00	240
474	23	39	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 95	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Gỏi tai heo", "Lẩu thái", "Bò nướng", "Cá kho"]}	8	2025-06-27 12:00:00	2025-06-27 14:00:00	120
476	23	32	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 93	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-22 12:00:00	2025-06-22 14:00:00	120
477	23	39	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 33	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-29 13:00:00	2025-06-29 17:00:00	240
478	23	31	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 10	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 18:00:00	2025-06-29 20:00:00	120
591	23	39	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.118945	\N	completed	f	\N	House 57	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-12 16:00:00	2025-06-12 18:00:00	120
220	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 34	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 11:00:00	2025-06-18 14:00:00	180
221	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 29	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-09 15:00:00	2025-07-09 17:00:00	120
334	23	37	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 72	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Bò nướng", "Gỏi tai heo"]}	8	2025-06-15 12:00:00	2025-06-15 15:00:00	180
446	23	31	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 32	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-25 17:00:00	2025-06-25 19:00:00	120
484	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 100	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-09 09:00:00	2025-06-09 13:00:00	240
494	23	34	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 22	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-22 14:00:00	2025-06-22 17:00:00	180
500	23	36	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 15	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-05 15:00:00	2025-07-05 17:00:00	120
217	23	37	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 40	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Gỏi tai heo", "Cá kho", "Lẩu thái", "Gà xào"]}	11	2025-06-12 14:00:00	2025-06-12 16:00:00	120
219	23	35	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 63	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-23 16:00:00	2025-06-23 20:00:00	240
336	23	32	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 87	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "3", "courses": ["Gà xào", "Bò nướng", "Lẩu thái", "Cá kho"]}	8	2025-06-18 09:00:00	2025-06-18 13:00:00	240
337	23	36	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 1	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Cá kho", "Bò nướng", "Lẩu thái", "Gỏi tai heo"]}	10	2025-06-12 15:00:00	2025-06-12 18:00:00	180
338	23	32	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 3	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-05 08:00:00	2025-07-05 10:00:00	120
339	23	30	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 8	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-21 15:00:00	2025-06-21 17:00:00	120
340	23	38	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 64	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-10 09:00:00	2025-06-10 13:00:00	240
482	23	34	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 36	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-02 08:00:00	2025-07-02 10:00:00	120
483	23	32	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 58	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 15:00:00	2025-06-18 19:00:00	240
485	23	31	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 100	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Bò nướng", "Gỏi tai heo"]}	10	2025-06-20 10:00:00	2025-06-20 14:00:00	240
486	23	38	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 92	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-06 09:00:00	2025-07-06 11:00:00	120
487	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 69	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-09 12:00:00	2025-06-09 16:00:00	240
488	23	32	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 96	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo", "Cá kho"]}	10	2025-07-04 10:00:00	2025-07-04 12:00:00	120
490	23	31	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 42	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Lẩu thái", "Gà xào", "Bò nướng", "Gỏi tai heo"]}	8	2025-06-20 14:00:00	2025-06-20 17:00:00	180
491	23	34	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 23	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "7", "courses": ["Gỏi tai heo", "Bò nướng", "Cá kho", "Lẩu thái"]}	11	2025-07-06 14:00:00	2025-07-06 18:00:00	240
492	23	38	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 48	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-05 15:00:00	2025-07-05 18:00:00	180
493	23	37	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 55	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 09:00:00	2025-06-19 11:00:00	120
496	23	36	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 17	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "7", "courses": ["Lẩu thái", "Bò nướng", "Gỏi tai heo"]}	11	2025-07-03 17:00:00	2025-07-03 20:00:00	180
497	23	39	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.123942	\N	completed	f	\N	House 36	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Cá kho", "Bò nướng"]}	10	2025-06-10 15:00:00	2025-06-10 18:00:00	180
520	23	39	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 33	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Gỏi tai heo", "Bò nướng", "Cá kho"]}	9	2025-06-13 11:00:00	2025-06-13 14:00:00	180
521	23	36	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 66	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Gỏi tai heo", "Gà xào"]}	10	2025-06-22 11:00:00	2025-06-22 14:00:00	180
522	23	36	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 57	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-27 10:00:00	2025-06-27 12:00:00	120
523	23	33	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 30	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-27 09:00:00	2025-06-27 13:00:00	240
534	23	39	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 56	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Gỏi tai heo", "Lẩu thái"]}	11	2025-07-09 17:00:00	2025-07-09 19:00:00	120
535	23	36	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 27	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 17:00:00	2025-06-18 19:00:00	120
536	23	30	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 35	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 13:00:00	2025-06-30 15:00:00	120
537	23	32	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 4	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gà xào", "Cá kho", "Bò nướng", "Lẩu thái"]}	10	2025-06-20 11:00:00	2025-06-20 15:00:00	240
539	23	37	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 15	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 11:00:00	2025-06-17 15:00:00	240
541	23	35	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 18	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-09 11:00:00	2025-06-09 15:00:00	240
590	23	31	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 42	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-25 13:00:00	2025-06-25 16:00:00	180
657	23	\N	20	Cafe Tina, Tân Phước, Phú Mỹ, Bà Rịa-Vũng Tàu	pending	\N	2025-06-17 10:32:23.050148	2025-06-17 10:32:23.050148	\N	completed	\N	\N	\N	220000	2025-06-17 10:32:23.050148	10.56669592	107.05919310	unpaid	{"workload": "4 rooms - 105m2"}	4	2025-06-20 09:00:00	2025-06-20 13:00:00	240
341	23	30	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 70	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 13:00:00	2025-06-14 15:00:00	120
470	23	36	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 96	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-09 12:00:00	2025-07-09 15:00:00	180
508	23	39	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 21	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-27 15:00:00	2025-06-27 19:00:00	240
509	23	36	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 19	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 17:00:00	2025-07-05 20:00:00	180
510	23	32	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 77	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-16 08:00:00	2025-06-16 10:00:00	120
511	23	36	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 44	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Gà xào", "Gỏi tai heo", "Bò nướng", "Lẩu thái"]}	11	2025-06-19 17:00:00	2025-06-19 19:00:00	120
524	23	32	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 3	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 18:00:00	2025-07-06 20:00:00	120
525	23	33	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 7	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-04 08:00:00	2025-07-04 11:00:00	180
658	23	\N	20	Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-17 10:36:07.402602	2025-06-17 10:36:07.402602	\N	completed	\N	\N	\N	220000	2025-06-17 10:36:07.402602	10.63030382	107.06965729	unpaid	{"workload": "4 rooms - 105m2"}	4	2025-06-20 05:00:00	2025-06-20 09:00:00	240
527	23	30	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 35	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 09:00:00	2025-06-18 12:00:00	180
533	23	33	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 2	180000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-24 18:00:00	2025-06-24 22:00:00	240
538	23	31	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 70	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 17:00:00	2025-06-14 19:00:00	120
647	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 47	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 08:00:00	2025-07-06 10:00:00	120
143	23	36	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.947922	\N	completed	f	\N	House 11	140000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-16 15:00:00	2025-06-16 18:00:00	180
249	23	31	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.952923	\N	completed	f	\N	House 72	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-13 12:00:00	2025-06-13 15:00:00	180
368	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.958922	\N	completed	f	\N	House 5	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-20 12:00:00	2025-06-20 16:00:00	240
369	23	30	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.964923	\N	completed	f	\N	House 75	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-22 11:00:00	2025-06-22 13:00:00	120
201	23	34	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.988946	\N	completed	f	\N	House 34	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-18 11:00:00	2025-06-18 15:00:00	240
514	23	37	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 81	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-19 14:00:00	2025-06-19 16:00:00	120
516	23	33	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 24	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 12:00:00	2025-06-29 14:00:00	120
517	23	38	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 82	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-28 17:00:00	2025-06-28 21:00:00	240
550	23	32	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 28	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-23 14:00:00	2025-06-23 16:00:00	120
561	23	32	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 89	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-30 16:00:00	2025-06-30 19:00:00	180
564	23	34	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 22	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 16:00:00	2025-06-17 18:00:00	120
567	23	31	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 32	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-12 17:00:00	2025-06-12 19:00:00	120
568	23	38	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 33	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 12:00:00	2025-06-29 15:00:00	180
569	23	38	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 17	295000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Gà xào", "Bò nướng", "Cá kho"]}	11	2025-07-02 11:00:00	2025-07-02 15:00:00	240
276	23	33	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 13	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Bò nướng", "Cá kho", "Gà xào", "Lẩu thái"]}	11	2025-06-18 14:00:00	2025-06-18 18:00:00	240
352	23	37	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 19	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Lẩu thái", "Bò nướng", "Cá kho"]}	11	2025-06-09 15:00:00	2025-06-09 17:00:00	120
393	23	32	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 51	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Gỏi tai heo", "Bò nướng", "Cá kho"]}	11	2025-06-12 13:00:00	2025-06-12 17:00:00	240
512	23	37	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 8	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-25 13:00:00	2025-06-25 15:00:00	120
515	23	34	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 36	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 10:00:00	2025-06-19 13:00:00	180
548	23	31	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 14	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 11:00:00	2025-07-06 14:00:00	180
555	23	34	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 7	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Gỏi tai heo", "Bò nướng", "Gà xào"]}	10	2025-06-25 16:00:00	2025-06-25 18:00:00	120
558	23	31	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 64	295000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Gà xào", "Bò nướng"]}	11	2025-06-21 17:00:00	2025-06-21 19:00:00	120
559	23	32	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 60	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 18:00:00	2025-07-03 20:00:00	120
562	23	36	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885471	\N	completed	f	\N	House 31	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Bò nướng", "Gà xào"]}	8	2025-06-26 09:00:00	2025-06-26 11:00:00	120
563	23	38	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 92	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 17:00:00	2025-07-08 19:00:00	120
566	23	31	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 92	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 12:00:00	2025-06-20 14:00:00	120
571	23	32	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 83	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-15 10:00:00	2025-06-15 14:00:00	240
61	23	32	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 14	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	\N	2025-06-25 11:00:00	2025-06-25 15:00:00	240
88	23	37	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 61	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Bò nướng", "Lẩu thái", "Gà xào"]}	9	2025-06-18 15:00:00	2025-06-18 17:00:00	120
184	23	33	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 86	255000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Bò nướng", "Gỏi tai heo"]}	10	2025-06-14 08:00:00	2025-06-14 12:00:00	240
659	23	30	20	Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-17 10:58:24.426202	2025-06-17 16:44:12.623699	\N	completed	\N	\N	\N	145000	2025-06-17 10:58:24.426202	10.58901677	107.06148012	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-06-21 07:00:00	2025-06-21 09:00:00	120
202	23	32	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.994946	\N	completed	f	\N	House 54	210000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-19 18:00:00	2025-06-19 21:00:00	180
574	23	32	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 88	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 15:00:00	2025-07-03 19:00:00	240
592	23	38	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 73	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-12 13:00:00	2025-06-12 17:00:00	240
593	23	36	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 47	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 13:00:00	2025-06-17 15:00:00	120
594	23	34	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 95	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Bò nướng", "Gà xào"]}	8	2025-06-16 13:00:00	2025-06-16 16:00:00	180
599	23	30	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 46	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-16 15:00:00	2025-06-16 18:00:00	180
519	23	33	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 90	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 08:00:00	2025-07-04 11:00:00	180
572	23	33	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 76	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-12 15:00:00	2025-06-12 18:00:00	180
573	23	38	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 27	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-14 18:00:00	2025-06-14 21:00:00	180
575	23	34	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 99	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-28 08:00:00	2025-06-28 10:00:00	120
576	23	30	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 7	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 13:00:00	2025-07-05 15:00:00	120
577	23	30	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 96	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Gỏi tai heo", "Bò nướng"]}	8	2025-06-24 13:00:00	2025-06-24 15:00:00	120
578	23	35	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 54	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Gỏi tai heo", "Lẩu thái", "Bò nướng", "Cá kho"]}	8	2025-07-03 14:00:00	2025-07-03 16:00:00	120
579	23	38	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 49	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-05 12:00:00	2025-07-05 14:00:00	120
580	23	37	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 8	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-10 13:00:00	2025-06-10 15:00:00	120
596	23	31	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 76	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Bò nướng", "Gỏi tai heo", "Cá kho", "Lẩu thái"]}	10	2025-06-29 14:00:00	2025-06-29 18:00:00	240
597	23	38	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 82	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Lẩu thái", "Cá kho"]}	9	2025-07-08 10:00:00	2025-07-08 12:00:00	120
598	23	34	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 97	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Cá kho", "Bò nướng"]}	10	2025-06-27 11:00:00	2025-06-27 13:00:00	120
101	23	34	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-24 09:18:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 9	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Cá kho", "Gỏi tai heo", "Gà xào", "Lẩu thái"]}	8	2025-07-05 08:00:00	2025-07-05 11:00:00	180
372	23	37	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.001608	\N	completed	f	\N	House 52	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Gỏi tai heo", "Lẩu thái"]}	10	2025-06-14 11:00:00	2025-06-14 14:00:00	180
373	23	39	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.009107	\N	completed	f	\N	House 73	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gà xào", "Gỏi tai heo", "Cá kho", "Lẩu thái"]}	11	2025-06-09 09:00:00	2025-06-09 12:00:00	180
375	23	37	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.015107	\N	completed	f	\N	House 50	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Bò nướng", "Gà xào", "Cá kho"]}	9	2025-06-11 18:00:00	2025-06-11 21:00:00	180
551	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.020107	\N	completed	f	\N	House 93	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-10 14:00:00	2025-06-10 16:00:00	120
329	23	36	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.032559	\N	completed	f	\N	House 94	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Bò nướng", "Cá kho", "Lẩu thái"]}	9	2025-06-20 17:00:00	2025-06-20 21:00:00	240
557	23	33	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.045576	\N	completed	f	\N	House 38	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-24 10:00:00	2025-06-24 13:00:00	180
632	23	31	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.051779	\N	completed	f	\N	House 57	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Bò nướng", "Lẩu thái", "Gỏi tai heo"]}	9	2025-06-11 14:00:00	2025-06-11 17:00:00	180
581	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.169852	\N	completed	f	\N	House 58	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-24 09:00:00	2025-06-24 13:00:00	240
616	23	35	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 41	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-28 12:00:00	2025-06-28 14:00:00	120
652	23	\N	20	Hoa Tươi Thiên An, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-17 09:40:06.34904	2025-06-17 09:40:06.34904	\N	completed	\N	\N	\N	180000	2025-06-17 09:40:06.34904	10.60550572	107.06311325	unpaid	{"workload": "3 rooms - 85m2"}	3	2025-06-19 08:00:00	2025-06-19 11:00:00	180
660	23	30	20	Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-23 22:39:23.241908	2025-06-23 22:39:23.241908	\N	completed	\N	\N	\N	145000	2025-06-23 22:39:23.241908	10.58901677	107.06148012	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-06-27 02:00:00	2025-06-27 04:00:00	120
661	23	30	20	80 Nguyễn Lương Bằng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-23 22:40:58.835099	2025-06-23 22:40:58.835099	\N	completed	\N	\N	\N	145000	2025-06-23 22:40:58.835099	10.59871520	107.05218021	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-06-26 08:00:00	2025-06-26 10:00:00	120
662	23	30	21	182 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-23 22:49:56.817914	2025-06-23 22:49:56.817914	\N	completed	\N	\N	\N	145000	2025-06-23 22:49:56.817914	10.59652526	107.06268622	unpaid	{"course": "2", "people": "2", "courses": "Hamburger, Spaghetti"}	8	2025-06-29 03:00:00	2025-06-29 05:00:00	120
600	23	39	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 23	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-09 09:00:00	2025-07-09 12:00:00	180
601	23	35	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 75	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Bò nướng", "Cá kho", "Gà xào"]}	11	2025-06-25 18:00:00	2025-06-25 22:00:00	240
602	23	35	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-07-01 20:30:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 73	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-21 15:00:00	2025-06-21 18:00:00	180
603	23	38	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 73	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 17:00:00	2025-07-04 20:00:00	180
604	23	30	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 33	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-03 16:00:00	2025-07-03 20:00:00	240
610	23	36	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 31	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-10 10:00:00	2025-06-10 13:00:00	180
615	23	39	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 15	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 10:00:00	2025-06-30 13:00:00	180
617	23	38	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 72	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-09 08:00:00	2025-06-09 11:00:00	180
619	23	31	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.885986	\N	completed	f	\N	House 25	255000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Bò nướng", "Gà xào", "Gỏi tai heo", "Lẩu thái"]}	10	2025-06-16 16:00:00	2025-06-16 19:00:00	180
620	23	33	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 33	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Lẩu thái", "Cá kho"]}	9	2025-07-04 09:00:00	2025-07-04 13:00:00	240
621	23	37	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 19	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-07 16:00:00	2025-07-07 18:00:00	120
623	23	32	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 7	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 10:00:00	2025-06-20 12:00:00	120
624	23	34	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 34	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-17 18:00:00	2025-06-17 21:00:00	180
625	23	35	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 16	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Lẩu thái", "Gà xào"]}	10	2025-07-09 10:00:00	2025-07-09 12:00:00	120
629	23	35	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 35	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 17:00:00	2025-07-04 19:00:00	120
631	23	32	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	in_progress	\N	2025-06-09 08:41:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 28	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-09 15:00:00	2025-07-09 17:00:00	120
52	23	30	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-24 22:28:41.796444	\N	completed	f	\N	House 22	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Bò nướng", "Gà xào", "Cá kho"]}	11	2025-06-10 15:00:00	2025-06-10 18:00:00	120
73	23	34	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-24 22:28:41.820602	\N	completed	f	\N	House 27	295000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Gà xào", "Gỏi tai heo", "Lẩu thái", "Bò nướng"]}	11	2025-06-24 16:00:00	2025-06-24 19:00:00	180
103	23	32	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.851397	\N	completed	f	\N	House 73	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-19 09:00:00	2025-06-19 11:00:00	120
104	23	35	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.858823	\N	completed	f	\N	House 89	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "4", "courses": ["Cá kho", "Bò nướng"]}	8	2025-06-12 11:00:00	2025-06-12 15:00:00	240
124	23	36	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 37	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 18:00:00	2025-07-04 22:00:00	240
638	23	38	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 31	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Lẩu thái", "Gỏi tai heo"]}	10	2025-06-30 10:00:00	2025-06-30 13:00:00	180
642	23	30	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 2	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Bò nướng", "Gà xào"]}	11	2025-06-09 14:00:00	2025-06-09 18:00:00	240
643	23	34	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 5	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 11:00:00	2025-07-04 15:00:00	240
62	23	38	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 41	210000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Gà xào", "Lẩu thái", "Gỏi tai heo"]}	\N	2025-07-09 12:00:00	2025-07-09 16:00:00	240
97	23	38	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 50	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Cá kho", "Lẩu thái"]}	9	2025-06-16 08:00:00	2025-06-16 10:00:00	120
100	23	35	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 79	295000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-27 17:00:00	2025-06-27 20:00:00	180
48	23	30	21	863 Nguyễn Xiển	assigned		2025-06-09 14:45:35.271333	2025-06-09 14:45:35.271333	string	completed	\N	\N	\N	192000	2025-06-09 14:45:35.271	0.00000000	0.00000000	paid	{"course": "3", "people": "6", "courses": ["Canh chua", "Rau muống xào", "Thịt kho"]}	5	2025-06-11 13:00:00	2025-06-11 17:00:00	240
125	23	32	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 67	295000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Gà xào", "Gỏi tai heo"]}	11	2025-07-01 18:00:00	2025-07-01 21:00:00	180
51	23	31	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.795376	2025-06-24 22:28:42.210501	\N	completed	f	\N	House 26	220000	2025-06-09 14:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 14:00:00	2025-06-10 16:00:00	120
639	23	38	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 84	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gỏi tai heo", "Gà xào", "Lẩu thái"]}	8	2025-07-08 12:00:00	2025-07-08 14:00:00	120
640	23	39	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.886004	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 40	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-20 11:00:00	2025-06-20 15:00:00	240
641	23	34	20	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 51	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-02 11:00:00	2025-07-02 13:00:00	120
644	23	34	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-07-01 10:50:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 16	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-03 12:00:00	2025-07-03 16:00:00	240
645	23	30	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 95	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 12:00:00	2025-06-30 15:00:00	180
650	23	36	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 91	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 13:00:00	2025-06-10 17:00:00	240
42	23	30	20	Nhà nghỉ Hoàng Nam, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-05-17 11:22:57.65165	2025-06-13 22:54:48.616		completed	f	\N	\N	140000	2025-05-28 22:54:47.448	10.59195159	107.06046017	paid	{"workload": "2 rooms - 55m2"}	2	2025-05-28 19:00:00	2025-05-28 21:00:00	120
105	23	35	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 9	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-11 13:00:00	2025-06-11 17:00:00	240
110	23	39	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 23	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-26 11:00:00	2025-06-26 14:00:00	180
121	23	33	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 20	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-02 12:00:00	2025-07-02 16:00:00	240
123	23	39	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 69	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-25 15:00:00	2025-06-25 17:00:00	120
203	23	30	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 24	255000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Cá kho", "Gà xào", "Gỏi tai heo"]}	10	2025-06-21 13:00:00	2025-06-21 15:00:00	120
250	23	35	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 81	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Cá kho", "Gỏi tai heo", "Lẩu thái"]}	8	2025-06-12 08:00:00	2025-06-12 10:00:00	120
280	23	32	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 54	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Lẩu thái", "Gà xào", "Cá kho", "Bò nướng"]}	8	2025-07-01 14:00:00	2025-07-01 16:00:00	120
318	23	34	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 43	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "4", "courses": ["Lẩu thái", "Gà xào"]}	8	2025-06-10 08:00:00	2025-06-10 11:00:00	180
370	23	31	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 29	255000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gà xào", "Cá kho", "Gỏi tai heo", "Bò nướng"]}	10	2025-06-28 15:00:00	2025-06-28 17:00:00	120
401	23	37	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 68	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "3", "courses": ["Gỏi tai heo", "Cá kho", "Gà xào"]}	9	2025-07-05 15:00:00	2025-07-05 19:00:00	240
122	23	39	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 92	210000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Lẩu thái", "Gà xào"]}	9	2025-06-25 18:00:00	2025-06-25 21:00:00	180
128	23	39	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 67	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Lẩu thái", "Cá kho", "Gỏi tai heo"]}	10	2025-06-17 18:00:00	2025-06-17 21:00:00	180
135	23	33	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 64	255000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Gà xào", "Cá kho", "Lẩu thái"]}	10	2025-07-06 08:00:00	2025-07-06 11:00:00	180
140	23	33	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 79	140000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 10:00:00	2025-06-17 13:00:00	180
145	23	32	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 7	165000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "4", "people": "6", "courses": ["Gà xào", "Bò nướng", "Lẩu thái"]}	8	2025-06-16 15:00:00	2025-06-16 19:00:00	240
172	23	31	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 80	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-07-04 14:00:00	2025-07-04 18:00:00	240
188	23	38	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 13	295000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Bò nướng", "Cá kho", "Lẩu thái"]}	11	2025-06-23 09:00:00	2025-06-23 11:00:00	120
215	23	35	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 6	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Lẩu thái", "Gà xào", "Cá kho"]}	9	2025-06-18 08:00:00	2025-06-18 10:00:00	120
230	23	38	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.880872	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 27	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-10 13:00:00	2025-06-10 15:00:00	120
265	23	38	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 68	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-05 08:00:00	2025-07-05 10:00:00	120
301	23	38	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.881893	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 21	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-01 10:00:00	2025-07-01 12:00:00	120
325	23	31	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 76	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "2", "courses": ["Lẩu thái", "Bò nướng", "Cá kho", "Gỏi tai heo"]}	9	2025-06-27 15:00:00	2025-06-27 19:00:00	240
345	23	38	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 24	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-19 17:00:00	2025-06-19 19:00:00	120
360	23	38	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 21	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-29 09:00:00	2025-06-29 12:00:00	180
385	23	33	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 28	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-07-04 18:00:00	2025-07-04 20:00:00	120
390	23	39	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.882877	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 26	295000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 10:00:00	2025-06-09 12:00:00	120
420	23	34	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 97	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-10 17:00:00	2025-06-10 19:00:00	120
435	23	31	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 69	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-07-04 08:00:00	2025-07-04 10:00:00	120
456	23	38	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.883925	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 73	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Lẩu thái", "Gà xào"]}	11	2025-06-19 16:00:00	2025-06-19 18:00:00	120
489	23	33	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 67	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Cá kho", "Gỏi tai heo", "Bò nướng"]}	8	2025-06-30 18:00:00	2025-06-30 20:00:00	120
114	23	39	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 11:01:01.796387	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 52	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-19 13:00:00	2025-06-19 16:00:00	180
229	23	34	20	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 73	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-26 08:00:00	2025-06-26 12:00:00	240
528	23	36	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 76	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-09 08:00:00	2025-06-09 12:00:00	240
529	23	38	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 91	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Bò nướng", "Cá kho"]}	9	2025-06-20 11:00:00	2025-06-20 15:00:00	240
545	23	37	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 20	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 10:00:00	2025-06-19 14:00:00	240
560	23	30	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 1	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-04 11:00:00	2025-07-04 14:00:00	180
588	23	30	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 13	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 17:00:00	2025-07-06 19:00:00	120
595	23	32	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 88	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 18:00:00	2025-06-14 20:00:00	120
605	23	32	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 6	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-16 16:00:00	2025-06-16 20:00:00	240
608	23	35	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 58	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-10 14:00:00	2025-06-10 18:00:00	240
611	23	39	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 24	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "5", "courses": ["Gà xào", "Bò nướng"]}	8	2025-07-09 17:00:00	2025-07-09 21:00:00	240
129	23	35	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 8	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-09 11:00:00	2025-07-09 15:00:00	240
130	23	32	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 14	255000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Bò nướng", "Cá kho"]}	10	2025-07-04 10:00:00	2025-07-04 12:00:00	120
532	23	33	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-10 15:01:52.796	2025-06-24 22:28:42.216647	\N	completed	f	\N	House 43	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 13:00:00	2025-06-14 15:00:00	120
232	23	39	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 35	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-13 11:00:00	2025-06-13 13:00:00	120
353	23	30	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.882877	\N	completed	f	\N	House 91	165000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "4", "courses": ["Gà xào", "Bò nướng"]}	8	2025-06-11 16:00:00	2025-06-11 18:00:00	120
495	23	31	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 80	210000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "2", "courses": ["Bò nướng", "Cá kho", "Gà xào"]}	9	2025-07-09 17:00:00	2025-07-09 19:00:00	120
505	23	30	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 87	210000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "3", "courses": ["Lẩu thái", "Gỏi tai heo", "Cá kho", "Bò nướng"]}	9	2025-06-21 13:00:00	2025-06-21 17:00:00	240
513	23	36	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 62	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-20 08:00:00	2025-06-20 10:00:00	120
518	23	36	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 38	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-26 15:00:00	2025-06-26 18:00:00	180
530	23	33	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.884426	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 36	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Cá kho", "Gỏi tai heo", "Bò nướng"]}	9	2025-06-11 08:00:00	2025-06-11 12:00:00	240
531	23	30	21	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 60	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Lẩu thái", "Bò nướng", "Gỏi tai heo"]}	11	2025-06-25 10:00:00	2025-06-25 14:00:00	240
606	23	32	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 19	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-13 17:00:00	2025-06-13 21:00:00	240
607	23	31	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 40	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-11 18:00:00	2025-06-11 20:00:00	120
609	23	32	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 21	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 10:00:00	2025-07-06 14:00:00	240
618	23	38	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.885481	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 52	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "5", "courses": ["Cá kho", "Bò nướng", "Gà xào"]}	8	2025-06-20 13:00:00	2025-06-20 17:00:00	240
622	23	36	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.886004	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 30	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-10 10:00:00	2025-06-10 12:00:00	120
630	23	35	26	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-08 22:50:13.886004	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 13	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-30 10:00:00	2025-06-30 12:00:00	120
228	23	31	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-10 15:01:52.796	2025-06-24 22:28:42.223845	\N	completed	f	\N	House 100	180000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-23 12:00:00	2025-06-23 16:00:00	240
651	23	\N	20	240 Đường Tôn Thất Tùng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	pending	\N	2025-06-15 11:07:16.713137	2025-06-15 11:07:16.713137	\N	completed	\N	\N	\N	145000	2025-06-15 11:07:16.713137	10.58852501	107.06930151	unpaid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 07:00:00	2025-06-17 10:00:00	180
295	23	30	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 77	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Gỏi tai heo", "Gà xào", "Lẩu thái", "Bò nướng"]}	10	2025-06-14 14:00:00	2025-06-14 16:00:00	120
445	23	33	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 82	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-06 14:00:00	2025-07-06 16:00:00	120
450	23	37	26	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.883925	\N	completed	f	\N	House 36	255000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-08 16:00:00	2025-07-08 19:00:00	180
465	23	33	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 70	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Cá kho", "Lẩu thái"]}	8	2025-06-22 12:00:00	2025-06-22 16:00:00	240
480	23	36	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 34	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-11 15:00:00	2025-06-11 18:00:00	180
540	23	36	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 47	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-24 15:00:00	2025-06-24 17:00:00	120
612	23	32	20	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 23	140000	\N	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-21 16:00:00	2025-06-21 18:00:00	120
613	23	33	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 83	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-07-02 18:00:00	2025-07-02 20:00:00	120
85	23	38	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 40	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-15 11:00:00	2025-06-15 13:00:00	120
170	23	34	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 65	255000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "6", "courses": ["Bò nướng", "Lẩu thái", "Gà xào"]}	10	2025-06-20 16:00:00	2025-06-20 19:00:00	180
175	23	30	20	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 31	220000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-24 17:00:00	2025-06-24 20:00:00	180
180	23	33	26	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 46	210000	2025-06-13 09:10:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-27 13:00:00	2025-06-27 17:00:00	240
195	23	30	20	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.880872	\N	completed	f	\N	House 10	140000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-07-04 13:00:00	2025-07-04 17:00:00	240
653	23	\N	21	124 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	pending	\N	2025-06-17 09:45:40.596668	2025-06-17 09:45:40.944705	\N	completed	\N	\N	\N	145000	2025-06-17 09:45:40.596668	10.59700261	107.06057849	paid	{"course": "2", "people": "4", "courses": "Gà xào xả ớt, Bò bóp thấu", "preferStyle": "Southern"}	8	2025-06-20 10:00:00	2025-06-20 12:00:00	120
106	23	33	26	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.867315	\N	completed	f	\N	House 1	165000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-19 15:00:00	2025-06-19 19:00:00	240
300	23	33	26	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 10	210000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-14 11:00:00	2025-06-14 13:00:00	120
315	23	38	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 75	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-22 15:00:00	2025-06-22 19:00:00	240
320	23	38	26	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.881893	\N	completed	f	\N	House 39	165000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-18 08:00:00	2025-06-18 11:00:00	180
475	23	31	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.884426	\N	completed	f	\N	House 36	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-09 09:00:00	2025-06-09 11:00:00	120
565	23	36	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 53	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-22 13:00:00	2025-06-22 17:00:00	240
570	23	35	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 12	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "7", "courses": ["Bò nướng", "Lẩu thái", "Gà xào"]}	11	2025-07-07 12:00:00	2025-07-07 16:00:00	240
614	23	37	21	248 Đường Trường Chinh, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	assigned	\N	2025-06-10 15:01:52.796	2025-06-08 22:50:13.885481	\N	completed	f	\N	House 58	255000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "2", "courses": ["Cá kho", "Gỏi tai heo"]}	10	2025-07-04 15:00:00	2025-07-04 18:00:00	180
626	23	36	21	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-30 12:01:52.796	2025-06-08 22:50:13.886004	\N	completed	f	\N	House 3	295000	\N	10.60429920	107.06293899	paid	{"course": "2", "people": "8", "courses": ["Lẩu thái", "Bò nướng", "Gỏi tai heo"]}	11	2025-06-23 14:00:00	2025-06-23 18:00:00	240
86	23	34	26	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 13	140000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{}	\N	2025-06-27 18:00:00	2025-06-27 21:00:00	180
87	23	31	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 11:01:01.796387	\N	completed	f	\N	House 84	180000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-30 13:00:00	2025-06-30 15:00:00	120
165	23	36	21	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	cancelled	\N	2025-06-15 11:01:01.796	2025-06-08 22:50:13.879878	\N	completed	f	\N	House 23	255000	2025-05-15 09:10:35.271	10.60429920	107.06293899	paid	{"course": "3", "people": "4", "courses": ["Bò nướng", "Gà xào", "Gỏi tai heo", "Lẩu thái"]}	10	2025-06-24 16:00:00	2025-06-24 18:00:00	120
204	23	32	20	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:41.874798	\N	completed	f	\N	House 80	140000	2025-06-14 09:10:35.271	10.60429920	107.06293899	paid	{"workload": "2 rooms - 55m2"}	2	2025-06-17 18:00:00	2025-06-17 22:00:00	240
152	23	37	21	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:41.890726	\N	completed	f	\N	House 27	255000	2025-05-30 10:45:35.271	10.60429920	107.06293899	paid	{"course": "2", "people": "5", "courses": ["Lẩu thái", "Gà xào", "Bò nướng", "Cá kho"]}	10	2025-06-19 14:00:00	2025-06-19 18:00:00	240
635	23	38	21	123 Nguyễn Huệ, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.058284	\N	completed	f	\N	House 69	165000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "7", "courses": ["Gỏi tai heo", "Gà xào", "Lẩu thái", "Bò nướng"]}	8	2025-06-11 10:00:00	2025-06-11 13:00:00	180
322	23	30	20	Bánh mì 123, Đường Nguyễn Văn Cừ, Phước Bình, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.082763	\N	completed	f	\N	House 30	180000	\N	10.60429920	107.06293899	paid	{"workload": "3 rooms - 85m2"}	3	2025-06-16 13:00:00	2025-06-16 15:00:00	120
506	23	39	21	Cơm tấm 123, Đường Nguyễn Thái Học, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.09557	\N	completed	f	\N	House 3	210000	\N	10.60429920	107.06293899	paid	{"course": "4", "people": "8", "courses": ["Cá kho", "Bò nướng", "Gà xào", "Gỏi tai heo"]}	9	2025-06-14 18:00:00	2025-06-14 21:00:00	180
583	23	39	26	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.10735	\N	completed	f	\N	House 99	220000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-17 15:00:00	2025-06-17 17:00:00	120
498	23	30	26	45 Lê Lợi, Long Hương, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.131598	\N	completed	f	\N	House 61	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-19 16:00:00	2025-06-19 19:00:00	180
499	23	37	26	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.138597	\N	completed	f	\N	House 67	140000	\N	10.60429920	107.06293899	paid	{}	\N	2025-06-11 08:00:00	2025-06-11 10:00:00	120
526	23	36	21	Pizza 789, Đường Võ Thị Sáu, Phước Hưng, Bà Rịa - Vũng Tàu	completed	\N	2025-06-10 15:01:52.796	2025-06-24 22:28:42.148607	\N	completed	f	\N	House 84	180000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "6", "courses": ["Bò nướng", "Gà xào"]}	9	2025-06-14 12:00:00	2025-06-14 16:00:00	240
546	23	32	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.15498	\N	completed	f	\N	House 44	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-18 11:00:00	2025-06-18 14:00:00	180
547	23	38	21	Bún bò chị hai, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.1627	\N	completed	f	\N	House 52	165000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "8", "courses": ["Bò nướng", "Gà xào", "Lẩu thái"]}	8	2025-06-22 13:00:00	2025-06-22 15:00:00	120
582	23	35	21	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-24 09:18:52.796	2025-06-24 22:28:42.174846	\N	completed	f	\N	House 63	220000	\N	10.60429920	107.06293899	paid	{"course": "3", "people": "2", "courses": ["Cá kho", "Bò nướng"]}	10	2025-06-14 10:00:00	2025-06-14 13:00:00	180
627	23	38	20	Quán cà phê 456, Đường Trần Phú, Phước Tân, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.188846	\N	completed	f	\N	House 23	220000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-17 12:00:00	2025-06-17 16:00:00	240
628	23	32	20	Quán ăn ngon, Đường Lê Duẩn, Phước Hòa, Bà Rịa - Vũng Tàu	completed	\N	2025-06-09 08:41:52.796	2025-06-24 22:28:42.195848	\N	completed	f	\N	House 36	210000	\N	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-18 10:00:00	2025-06-18 14:00:00	240
120	23	37	20	78 Trần Hưng Đạo, Phước Trung, Bà Rịa - Vũng Tàu	completed	\N	2025-06-10 15:01:52.796	2025-06-24 22:28:42.201846	\N	completed	f	\N	House 59	220000	2025-05-05 10:45:35.271	10.60429920	107.06293899	paid	{"workload": "4 rooms - 105m2"}	4	2025-06-14 17:00:00	2025-06-14 19:00:00	120
\.


--
-- TOC entry 5366 (class 0 OID 45386)
-- Dependencies: 248
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_messages (id, room_id, sender_type, sender_id, message_text, sent_at, read_at) FROM stdin;
94	7	tasker	30	hi, got the job	2025-06-17 16:44:50.351527	2025-06-17 00:00:00
95	7	user	23	oke, please come right time	2025-06-17 16:45:27.929342	2025-06-17 00:00:00
96	7	tasker	30	ok sir, can u provide ur phone	2025-06-17 16:46:07.842198	2025-06-17 00:00:00
97	7	user	23	034765234	2025-06-17 16:46:19.536908	2025-06-17 00:00:00
\.


--
-- TOC entry 5364 (class 0 OID 45375)
-- Dependencies: 246
-- Data for Name: chat_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_rooms (id, booking_id, user_id, tasker_id, created_at, last_message_at) FROM stdin;
7	659	23	30	2025-06-17 16:44:22.617051	2025-06-17 16:46:19.539078
\.


--
-- TOC entry 5378 (class 0 OID 45491)
-- Dependencies: 260
-- Data for Name: chatbot_interactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatbot_interactions (id, user_id, query, response, created_at) FROM stdin;
14	23	có hỗ trợ cuối tuần không?	Here are the answers to the user's questions based on the provided data:\n\n27. Nếu tôi quên mật khẩu, tôi phải làm gì để lấy lại?\nTôi phải liên hệ hotline 0347596789 để được hỗ trợ.\n\n28. Làm thế nào để xóa tài khoản trên ứng dụng?\nTôi phải đăng nhập vào tài khoản, chọn "Tài khoản" và sau đó chọn "Xóa tài khoản".\n\n29. Sau khi xóa tài khoản, tôi có thể dùng lại email để đăng ký mới không?\nKhông, sau khi xóa tài khoản, tôi không thể sử dụng lại email để đăng ký mới.\n\n30. Chính sách bảo mật của ứng dụng tuân theo quy định nào?\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.\n\n31. Ứng dụng có hỗ trợ dịch vụ vào ngày lễ không?\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.\n\n32. Tôi cần liên hệ ai nếu có khiếu nại về dịch vụ?\nTôi cần liên hệ hotline 0347596789 để được hỗ trợ.\n\n33. Hotline hỗ trợ khách hàng của ứng dụng là số nào?\n0347596789.\n\n34. Ứng dụng đang trong giai đoạn nào? Có hạn chế gì không?\n Ứng dụng đang trong giai đoạn thử nghiệm, có thể còn thiếu sót.\n\nCâu hỏi về hỗ trợ và lưu ý chung: \n\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.\n\nNgay trên!	2025-06-17 10:02:24.777976
15	23	dọn dẹp nhà 50m2 giá bao nhiêu	Câu hỏi: Dọn dẹp nhà 50m2 giá bao nhiêu?\n\nTrả lời: Dựa vào bảng giá, tính 2.000 VNĐ/m² cho diện tích từ 40 m² đến 60 m². Tổng chi phí: 50 m² x 2.000 VNĐ = 100.000 VNĐ.	2025-06-17 10:14:30.765367
16	23	Quên mật khẩu thì có cách nào đặt lại được	Here are the answers to the user's questions:\n\n21. Làm thế nào để đặt lịch dọn dẹp nhà trên ứng dụng?\nĐể đặt lịch dọn dẹp nhà trên ứng dụng, bạn cần chọn dịch vụ "Dọn dẹp nhà" và nhập diện tích nhà cần dọn dẹp, sau đó chọn ngày và giờ nhận việc.\n\n22. Tôi cần cung cấp thông tin gì khi đặt lịch sửa điều hòa?\nKhi đặt lịch sửa điều hòa, bạn cần cung cấp thông tin về loại điều hòa (ceiling-mounted hoặc split), công suất của điều hòa và địa chỉ của nhà.\n\n23. Có thể đặt lịch dịch vụ vào cuối tuần không? Có lưu ý gì đặc biệt không?\nCó thể đặt lịch dịch vụ vào cuối tuần, nhưng cần xác nhận với quản lý tòa nhà nếu ở chung cư. Khuyến nghị: Đặt lịch sớm 1-2 ngày vào cuối tuần hoặc dịp lễ để đảm bảo có Tasker nhận việc.\n\n24. Tôi muốn đặt dịch vụ nấu ăn cho 5 người, quy trình đặt lịch ra sao?\nĐể đặt dịch vụ nấu ăn cho 5 người, bạn cần chọn dịch vụ "Nấu ăn" và nhập số lượng người cần nấu ăn, sau đó chọn ngày và giờ nhận việc.\n\n25. Làm sao để xác nhận thời gian và địa điểm khi đặt dịch vụ?\nKhi đặt dịch vụ, bạn cần xác nhận thời gian và địa điểm nhận việc với Tasker.\n\n26. Thông tin cá nhân của tôi có được bảo mật khi sử dụng ứng dụng không?\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.\n\n35. Nếu tôi ở chung cư, có cần lưu ý gì khi đặt dịch vụ vào cuối tuần?\nCần xác nhận với quản lý tòa nhà nếu ở chung cư.\n\n36. Tôi muốn dọn dẹp nhà 90 m² và nấu ăn cho 4 người với 3 món trong 2 giờ, tổng chi phí là bao nhiêu?\nTổng chi phí: Dọn dẹp nhà 90 m² = 180.000 VNĐ (2.000 VNĐ/m²); Nấu ăn cho 4 người với 3 món trong 2 giờ = 400.000 VNĐ. Tổng chi phí: 180.000 VNĐ + 400.000 VNĐ = 580.000 VNĐ.\n\n37. Nếu tôi đặt dịch vụ sửa điều hòa ceiling-mounted 2.5 HP và hủy trước 3 tiếng, tôi phải trả bao nhiêu phí?\nPhí hủy: 30% của giá dịch vụ (42.000 VNĐ).\n\n38. Tôi có thể đặt dịch vụ dọn dẹp nhà 50 m² vào Chủ nhật và thanh toán bằng VNPAY không?\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.\n\n39. Dịch vụ nấu ăn cho 7 người, 4 món, trong 3.5 giờ có yêu cầu gì đặc biệt không?\nKhông có yêu cầu đặc biệt.	2025-06-17 10:14:52.675011
17	23	Tôi có thể thanh toán bằng cách nào	Here are the answers to the user's questions based on the provided data:\n\n16. Tôi có thể thanh toán dịch vụ dọn dẹp nhà bằng cách nào?\nBạn có thể thanh toán dịch vụ dọn dẹp nhà bằng cách sử dụng ví điện tử hPay trên ứng dụng.\n\n17. Ví điện tử hPay hoạt động như thế nào trên ứng dụng?\nVí điện tử hPay cho phép bạn thanh toán các dịch vụ trên ứng dụng một cách nhanh chóng và an toàn.\n\n18. Nếu tôi tự hủy đơn dọn dẹp nhà trước 1 tiếng, tôi được hoàn tiền bao nhiêu?\nBạn sẽ được hoàn tiền 50% của giá dịch vụ dọn dẹp nhà.\n\n19. Tasker hủy đơn sửa điều hòa của tôi, tôi sẽ được hoàn tiền như thế nào?\nBạn sẽ được hoàn tiền đầy đủ của giá dịch vụ sửa điều hòa.\n\n20. Tôi có thể thanh toán bằng VNPAY cho dịch vụ nấu ăn không?\nCó, bạn có thể thanh toán dịch vụ nấu ăn bằng VNPAY.\n\n21. Làm thế nào để đặt lịch dọn dẹp nhà trên ứng dụng?\nĐể đặt lịch dọn dẹp nhà, bạn hãy truy cập ứng dụng, chọn dịch vụ dọn dẹp nhà, chọn ngày và giờ yêu cầu, và sau đó xác nhận.\n\n22. Tôi cần cung cấp thông tin gì khi đặt lịch sửa điều hòa?\nBạn cần cung cấp thông tin về công suất máy điều hòa, địa điểm và thời gian yêu cầu.\n\n23. Có thể đặt lịch dịch vụ vào cuối tuần không? Có lưu ý gì đặc biệt không?\nCó, bạn có thể đặt lịch dịch vụ vào cuối tuần. Tuy nhiên, các dịch vụ có thể có hạn chế về giờ hoạt động và số lượng người lao động.\n\n24. Tôi muốn đặt dịch vụ nấu ăn cho 5 người, quy trình đặt lịch ra sao?\nĐể đặt dịch vụ nấu ăn cho 5 người, bạn hãy truy cập ứng dụng, chọn dịch vụ nấu ăn, chọn ngày và giờ yêu cầu, và sau đó xác nhận.\n\n25. Làm sao để xác nhận thời gian và địa điểm khi đặt dịch vụ?\nBạn có thể xác nhận thời gian và địa điểm khi đặt dịch vụ bằng cách chọn giờ và ngày yêu cầu và sau đó xác nhận.\n\n26. Thông tin cá nhân của tôi có được bảo mật khi sử dụng ứng dụng không?\nVui lòng liên hệ hotline 0347596789 để được hỗ trợ.	2025-06-17 10:15:15.023936
\.


--
-- TOC entry 5344 (class 0 OID 45244)
-- Dependencies: 226
-- Data for Name: favorite_tasker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_tasker (id, user_id, tasker_id, service_id) FROM stdin;
5	23	30	21
\.


--
-- TOC entry 5402 (class 0 OID 46142)
-- Dependencies: 284
-- Data for Name: fcm_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fcm_tokens (id, token, user_id, tasker_id, device_id, created_at, updated_at) FROM stdin;
1	f3SVZ0qZRpW0_-FQcpBMSo:APA91bEg4eqPzKn4gHmuO5iRX7Qnu1qka4krMnQdGM8iypYfVMSG02koHMF6o2Xlzcj6nhBC2KW3us6U5HCqYx428XAiOIlLfccU-LW4iVB60ubMBxMZ0jc	\N	30	QP1A.190711.020	\N	2025-06-17 16:42:36.283772
2	fZ-aLQdAQVKhKDSuiFycR_:APA91bGpJN2esXlEDPUjLGEGSsBj_xJfsvMKZOaj6lS7sMs9AATzCs9lsfsM0lYqjbi4ZNPSHauvq6Qnwq8b3o0YPkl063LQjx23Jvm_19STSY6KntQhVPI	23	\N	QP1A.190711.020	\N	2025-06-24 11:25:38.989458
\.


--
-- TOC entry 5395 (class 0 OID 46017)
-- Dependencies: 277
-- Data for Name: package_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package_variants (id, package_id, variant_name, variant_description, additional_price, is_deleted) FROM stdin;
1	5	≤ 2HP	less than 2hp	\N	f
2	5	> 2HP	more than 2hp	20000	f
3	7	≤ 3HP	less than 3hp	\N	f
4	7	> 3HP	more than 3hp	70000	f
5	8	02–03 dishes, 02–04 persons	Basic family size	20000	f
6	9	02–03 dishes, 05–08 persons\t	Basic family size	30000	f
7	10	04 dishes, 02 - 04 persons	\N	35000	f
8	11	04 dishes, 05–08 persons\t	\N	45000	f
9	6	≤ 3HP	less than 3hp	\N	f
10	6	> 3HP	more than 3hp	50000	f
\.


--
-- TOC entry 5356 (class 0 OID 45333)
-- Dependencies: 238
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, booking_id, user_id, tasker_id, amount, currency, status, transaction_id, payment_date, refund_amount, refund_reason, refund_date, payment_gateway, gateway_response, receipt_url, method_type) FROM stdin;
22	652	23	\N	180000.00	VND	pending	INV_1750128006241	\N	0.00	\N	\N	cash	\N	\N	cash
23	653	23	\N	145000.00	VND	completed	INV_1750128340595	\N	0.00	\N	\N	bank_transfer	\N	\N	bank_transfer
24	654	23	\N	145000.00	VND	pending	INV_1750130213944	\N	0.00	\N	\N	cash	\N	\N	cash
25	655	23	\N	180000.00	VND	pending	INV_1750130328117	\N	0.00	\N	\N	cash	\N	\N	cash
26	656	23	\N	180000.00	VND	pending	INV_1750130365487	\N	0.00	\N	\N	cash	\N	\N	cash
27	657	23	\N	220000.00	VND	pending	INV_1750131143049	\N	0.00	\N	\N	cash	\N	\N	cash
28	658	23	\N	220000.00	VND	pending	INV_1750131367401	\N	0.00	\N	\N	cash	\N	\N	cash
29	659	23	\N	145000.00	VND	pending	INV_1750132704426	\N	0.00	\N	\N	cash	\N	\N	cash
30	660	23	30	145000.00	VND	pending	INV_1750693162694	\N	0.00	\N	\N	cash	\N	\N	cash
31	661	23	30	145000.00	VND	pending	INV_1750693258834	\N	0.00	\N	\N	cash	\N	\N	cash
32	662	23	30	145000.00	VND	pending	INV_1750693796817	\N	0.00	\N	\N	cash	\N	\N	cash
\.


--
-- TOC entry 5374 (class 0 OID 45441)
-- Dependencies: 256
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, methods, description, created_at, method_path) FROM stdin;
2	POST	update address customer	2025-04-19 09:16:23.930342	/user/address
3	DELETE	deactive account user	2025-04-19 09:17:40.159844	/user/delete
4	PUT	assign tasker to booking	2025-04-19 09:22:58.304182	/booking/\\d+/assign-tasker
5	PUT	tasker completed job	2025-04-19 09:24:08.672618	/booking/completed-booking
8	POST	customer/tasker review each other	2025-04-19 09:27:12.578525	/booking/review
11	POST	customer register account	2025-04-19 09:30:01.762765	/register/user
12	POST	tasker register account	2025-04-19 09:30:42.198836	/register/tasker
13	GET	get room chat	2025-04-19 09:31:53.104444	/chat/user/
15	GET	get message recent	2025-04-19 09:33:32.680932	/chat/message/\\d+/recent
16	GET	search user	2025-04-19 09:35:41.270594	/user/sort-by-column-and-search
17	GET	search tasker	2025-04-19 09:36:19.662248	/user/sort-tasker-by-column-and-search
18	GET	get all user	2025-04-19 09:37:22.275315	/user/list
19	GET	get all tasker	2025-04-19 09:37:36.592746	/user/list-tasker
20	PUT	update sevice category	2025-04-19 09:38:32.373303	/service/update
21	PUT	update service	2025-04-19 09:38:55.056969	/service/update-service
22	POST	add service category	2025-04-19 09:39:21.571442	/service/category
23	POST	add service	2025-04-19 09:39:44.057067	/service/add-service
24	GET	get all service	2025-04-19 09:40:15.27245	/service/list-service
25	DELETE	delete category service	2025-04-19 09:40:46.958864	/service/delete
26	DELETE	delete service	2025-04-19 09:41:26.382391	/service/delete-service
27	GET	get tasker profile	2025-06-01 17:35:34.581704	/tasker/profile/.*
28	GET	get USER profile	2025-06-01 17:36:10.294878	/user/profile/.*
31	POST	get FCM register	2025-06-01 20:09:49.222235	/notifications/fcm/register
32	GET	CHAT WEBSOCKET	2025-06-01 21:25:14.621686	/ws
14	GET	get message for chat room	2025-04-19 09:32:48.671737	/chat/message/\\d+
34	GET	GET NOTIFICATION FOR TASKER	2025-06-01 23:24:19.07348	/notifications/taskers/\\d+
35	GET	GET TASK WAS ASSIGNED BY DATE	2025-06-01 23:26:00.641003	/booking/\\d+/get-task-assigned-by-date
36	POST	Create chat room	2025-06-03 10:21:35.263882	/chat/rooms/create
37	POST	Assigned Tasker	2025-06-03 11:19:58.581513	/booking/\\d+/assign-tasker
38	POST	Save conversation	2025-06-06 10:24:56.788612	/chatbot/save
57	POST	Deduct	2025-06-15 16:48:36.565796	/wallet/deduct
39	GET	Get chatbot conversation	2025-06-06 11:13:24.670603	/chatbot/\\d+/chatbot-conversation
40	GET	Get notification for user	2025-06-06 22:22:03.852456	/notifications/users/\\d+
30	GET	get notification unread for tasker	2025-06-01 20:09:23.440349	/notifications/taskers/\\d+/unread-count
41	GET	Get notification unread for user	2025-06-06 22:22:36.093827	/notifications/users/\\d+/unread-count
42	PUT	Mark as read notification	2025-06-06 22:24:43.327627	/notifications/users/\\d+/read
59	DELETE	Delete favorite tasker	2025-06-15 16:48:36.565796	/user/delete-favorite-tasker/\\d+
58	POST	Add Favorite Tasker	2025-06-15 16:48:36.565796	/user/add-favorite-tasker/\\d+
44	DELETE	Delete tasker notification	2025-06-06 23:42:58.879283	/notifications/tasker/delete/\\d+
43	DELETE	Delete user notification	2025-06-06 23:42:58.879283	/notifications/user/delete/\\d+
45	POST	Review	2025-06-07 11:06:33.673086	/booking/review
29	GET	get all task for tasker	2025-06-01 20:08:17.248539	/booking/all-task-for-tasker/\\d+
9	POST	create booking	2025-04-19 09:28:38.046638	/booking/create-booking
60	GET	Get all favorite taskers	2025-06-15 16:48:36.565796	/user/get-favorite-tasker/\\d+
1	POST	update information user	2025-04-19 09:15:43.229844	/user/update-with-image/\\d+
6	PUT	customer cancel job	2025-04-19 09:25:40.54113	/booking/\\d+/cancel-booking-by-user
53	GET	Get history task	2025-06-07 11:06:33.673086	/booking/\\d+/get-history-tasks
54	GET	Get packages	2025-06-15 10:56:36.464907	/service/list-service-package/\\d+
10	GET	get detail job	2025-04-19 09:29:22.031214	/booking/\\d+/booking-detail
55	GET	Get user wallet	2025-06-15 16:48:06.75388	/wallet/user/\\d+
56	POST	Recharge	2025-06-15 16:48:36.565796	/wallet/recharge/
7	PUT	tasker cancel job	2025-04-19 09:26:10.623491	/booking/\\d+/cancel-booking-by-tasker
61	GET	GET SERVICE OF TASKER	2025-06-15 16:48:36.565796	/tasker/get-service-tasker/\\d+
\.


--
-- TOC entry 5406 (class 0 OID 46246)
-- Dependencies: 288
-- Data for Name: review_features; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_features (id, sentiment_label, sentiment_confidence, reputation_score) FROM stdin;
1	1	0.7222222222222222	2.529684076363962
2	1	0.7222222222222222	2.779573128844278
3	1	0.7222222222222222	2.39482169556355
4	1	0.7	2.7702927514945754
5	-1	0.7	0.5114037390625237
6	1	0.7	1.4479148183803512
7	-1	0.8	1.110970798975587
8	1	0.7222222222222222	2.853748594761342
9	1	0.7	2.50443679105879
10	1	0.8	2.3988337492522067
11	1	0.7	2.479883321532538
12	1	0.7	1.641401220708147
13	-1	0.8	1.5698976981733792
14	1	0.8	1.3287056118016025
15	1	0.7857142857142857	2.3415315510578196
16	1	0.7222222222222222	2.242157792663745
17	1	0.7	2.1056555826776013
18	-1	0.7	0.7759862105822887
19	1	0.7222222222222222	2.7010846918615368
20	1	0.7	1.5967938909170059
21	1	0.7	2.7702927514945754
22	1	0.7	2.479883321532538
23	0	0.6	2.020956422334746
24	-1	0.7	0.5114037390625237
25	0	0.6	1.7589364211497365
26	-1	0.8	1.248479160516579
27	1	0.7	2.7702927514945754
28	1	0.7	2.3113658522967837
29	1	0.8	1.7876325109993947
30	-1	0.7	1.138978810670336
31	1	0.8	1.7876325109993947
32	1	0.7222222222222222	2.5395060813273584
33	1	0.8	2.417429214917905
34	-1	0.8	0.9594940111230175
35	1	0.8	1.4995754165223207
36	1	0.8	3.33440822941569
37	1	0.7	0.988987919182559
38	1	0.7	2.3113658522967837
39	1	0.7222222222222222	1.621652282931774
40	1	0.7	2.564582481875393
41	1	0.7	2.4720009951021624
42	1	0.7	2.4720009951021624
43	1	0.7857142857142857	2.800458450255612
44	-1	0.8	1.248479160516579
45	1	0.8	1.7876325109993947
46	1	0.6818181818181819	2.1555351107733665
47	-1	0.7	0.5114037390625237
48	-1	0.7	1.5979057098681282
49	1	0.7222222222222222	2.39482169556355
50	1	0.7222222222222222	2.242157792663745
51	1	0.7222222222222222	2.242157792663745
52	1	0.7222222222222222	2.080579182129566
53	1	0.7	1.4479148183803512
54	-1	0.7	0.9948268377279827
55	-1	0.7	0.3829568763233569
56	-1	0.7	1.2349131097800807
57	1	0.8	1.3287056118016025
58	0	0.6	2.1106586374897347
59	-1	0.8	1.4184209103208096
60	1	0.7222222222222222	2.5395060813273584
61	1	0.7222222222222222	1.621652282931774
62	1	0.7	2.1003281199059387
63	1	0.7	2.963363690256582
64	1	0.8	3.33440822941569
65	-1	0.7	1.6517317382919425
66	-1	0.7	0.3829568763233569
67	-1	0.7	0.9703306382603157
68	-1	0.7	1.5979057098681282
69	-1	0.7	1.3000095219519443
70	1	0.7	2.1056555826776013
71	1	0.7857142857142857	2.800458450255612
72	0	0.6	2.1106586374897347
73	-1	0.8	1.4184209103208096
74	-1	0.7	1.138978810670336
75	1	0.7	2.7702927514945754
76	1	0.7	1.5967938909170059
77	-1	0.8	1.110970798975587
78	-1	0.8	1.3033634023181904
79	1	0.7222222222222222	2.779573128844278
80	-1	0.8	1.4184209103208096
81	-1	0.7	0.7759862105822887
82	1	0.7222222222222222	2.5395060813273584
83	1	0.7	2.3113658522967837
84	1	0.8	2.3988337492522067
85	1	0.7	2.564582481875393
86	-1	0.7	0.3829568763233569
87	1	0.8	2.8577606484499984
88	-1	0.7	1.5620295231369539
89	0	0.6	2.020956422334746
90	0	0.6	2.1106586374897347
91	0	0.6	2.1106586374897347
92	1	0.7	1.4479148183803512
93	1	0.8	2.3988337492522067
94	-1	0.7	0.9948268377279827
95	1	0.7	2.1003281199059387
96	1	0.7222222222222222	2.779573128844278
97	-1	0.7	1.2349131097800807
98	-1	0.7	1.138978810670336
99	-1	0.8	1.110970798975587
100	-1	0.7	0.3829568763233569
152	-1	0.8	1.5698976981733792
153	1	0.8	2.2375105282919185
154	1	0.8	1.9553028676935162
155	1	0.75	2.1495080824555766
156	-1	0.8	1.4184209103208096
157	-1	0.8	0.9594940111230175
158	1	0.7	1.0713559741671757
159	1	0.7	2.6585411990597736
160	1	0.7	1.0713559741671757
161	1	0.7	1.5302828733649676
162	-1	0.7	1.5979057098681282
163	1	0.8	2.6964374274897103
164	1	0.8	1.496375968495724
165	-1	0.8	1.5342978641353873
166	1	0.7222222222222222	2.4596577754882127
167	1	0.8	2.8577606484499984
168	1	0.6818181818181819	2.3262272190116065
169	1	0.8	3.33440822941569
170	1	0.7	2.6585411990597736
171	1	0.7	1.5967938909170059
172	1	0.8	2.3913164219827783
173	1	0.7222222222222222	1.621652282931774
174	-1	0.7	1.2349131097800807
175	-1	0.7	0.8005260627294563
176	1	0.8	2.85024332118057
177	1	0.7222222222222222	2.853748594761342
178	1	0.8	2.6964374274897103
179	-1	0.7	1.5979057098681282
180	1	0.7222222222222222	2.4596577754882127
181	1	0.8	2.414229766891308
182	1	0.8	1.958502315720113
183	1	0.7	2.479883321532538
184	-1	0.8	1.0753709649375953
185	1	0.6666666666666666	1.4791501489180916
186	1	0.7	1.4479148183803512
187	1	0.6666666666666666	1.9380770481158835
188	0	0.6	2.1996142998619814
189	1	0.7	2.184248419566656
190	1	0.6818181818181819	1.6966082115755745
191	1	0.7222222222222222	2.4596577754882127
192	-1	0.7	1.2594529619272483
193	1	0.7	2.7702927514945754
194	1	0.7222222222222222	1.1669670638150411
195	-1	0.8	1.0753709649375953
196	1	0.7222222222222222	2.918584674686005
197	1	0.7	2.5779927997312324
198	1	0.6666666666666666	1.4791501489180916
199	1	0.75	2.1495080824555766
200	-1	0.7	1.3000095219519443
201	1	0.7	2.50443679105879
202	1	0.8	2.414229766891308
203	-1	0.8	0.4928519996951288
204	1	0.7	2.6585411990597736
205	1	0.8	2.8577606484499984
206	1	0.8	2.3913164219827783
207	1	0.7	2.121224820593533
208	1	0.7	2.1003281199059387
209	-1	0.8	0.8444365031203982
210	1	0.7222222222222222	2.779573128844278
211	1	0.7222222222222222	1.625893963012833
212	-1	0.7	1.3140687983379553
213	1	0.8	2.3988337492522067
214	1	0.7	2.1003281199059387
215	1	0.8	1.3287056118016025
216	1	0.7	1.455404910891611
217	1	0.7222222222222222	1.1669670638150411
218	-1	0.8	0.9517788988929208
219	0	0.6	1.7253215203688637
220	1	0.8	2.3988337492522067
221	-1	0.7	0.8551418991401631
222	0	0.6	1.7589364211497365
223	1	0.7222222222222222	2.5563226069347182
224	1	0.6818181818181819	2.6144620099711586
225	1	0.8	2.85024332118057
226	0	0.6	1.7253215203688637
227	1	0.8	2.3913164219827783
228	1	0.7857142857142857	2.800458450255612
229	0	0.6	2.1996142998619814
230	1	0.6818181818181819	2.3262272190116065
231	-1	0.7	1.2594529619272483
232	1	0.7222222222222222	2.5395060813273584
233	1	0.7	2.121224820593533
234	1	0.7857142857142857	2.3415315510578196
235	1	0.7857142857142857	2.800458450255612
236	-1	0.75	1.5025084931741168
237	1	0.7	2.7702927514945754
238	1	0.7	2.373258709287195
239	1	0.8	1.7876325109993947
240	-1	0.7	0.9811792868036988
241	-1	0.7	1.3140687983379553
242	-1	0.8	0.9594940111230175
243	1	0.7	2.3113658522967837
244	-1	0.75	1.5025084931741168
245	-1	0.8	0.7895522613187869
246	1	0.6818181818181819	2.785154118209398
247	-1	0.7	0.8551418991401631
248	0	0.6	2.020956422334746
249	1	0.8	1.4995754165223207
250	-1	0.7	1.5979057098681282
251	1	0.7222222222222222	2.779573128844278
252	1	0.7222222222222222	1.625893963012833
253	1	0.7	2.4720009951021624
254	-1	0.7	1.5979057098681282
255	1	0.7222222222222222	2.5563226069347182
256	1	0.8	2.3913164219827783
257	1	0.7	1.0713559741671757
258	1	0.8	2.8577606484499984
259	1	0.8	2.85024332118057
260	1	0.8	2.2375105282919185
261	-1	0.7	1.6517317382919425
262	1	0.8	2.3988337492522067
263	1	0.8	2.246559410197187
264	1	0.7	1.554147196706578
265	-1	0.7	1.4401061860014908
266	-1	0.8	1.5698976981733792
267	-1	0.8	1.5342978641353873
268	1	0.7	2.5779927997312324
269	1	0.7	2.7702927514945754
270	1	0.7222222222222222	2.080579182129566
271	1	0.75	2.6084349816533683
272	-1	0.75	1.0435815939763249
273	1	0.75	2.1495080824555766
274	-1	0.75	1.1048848985546138
275	-1	0.7	1.3000095219519443
276	-1	0.7	0.8005260627294563
277	1	0.6818181818181819	2.3262272190116065
278	1	0.75	2.1495080824555766
279	1	0.6666666666666666	1.4791501489180916
280	1	0.7222222222222222	1.625893963012833
281	1	0.7	2.121224820593533
282	0	0.6	2.020956422334746
283	1	0.7	2.3113658522967837
284	1	0.7	0.988987919182559
285	1	0.7	1.5967938909170059
286	1	0.7	2.184248419566656
287	-1	0.7	1.4401061860014908
288	-1	0.7	1.6517317382919425
289	-1	0.8	1.5342978641353873
290	-1	0.7	0.3829568763233569
291	-1	0.8	0.9517788988929208
292	-1	0.7	1.2594529619272483
293	1	0.7	2.373258709287195
294	1	0.7	2.479883321532538
295	1	0.7	1.455404910891611
296	1	0.7222222222222222	2.779573128844278
297	1	0.6666666666666666	2.3970039473136757
298	1	0.8	2.8577606484499984
299	-1	0.8	1.110970798975587
300	1	0.7	2.564582481875393
301	1	0.8	1.496375968495724
302	1	0.7857142857142857	2.800458450255612
303	1	0.8	2.2375105282919185
304	1	0.8	2.8577606484499984
305	-1	0.7	0.8551418991401631
306	1	0.8	2.85024332118057
307	-1	0.7	1.6517317382919425
308	0	0.6	1.7253215203688637
309	1	0.6818181818181819	2.1555351107733665
310	-1	0.7	0.9811792868036988
311	1	0.6818181818181819	1.6966082115755745
312	1	0.6666666666666666	2.3970039473136757
313	1	0.8	3.33440822941569
314	1	0.8	1.496375968495724
315	-1	0.7	0.8551418991401631
316	-1	0.75	1.5638117977524058
317	1	0.7	1.5302828733649676
318	-1	0.7	1.3140687983379553
319	1	0.7222222222222222	1.1669670638150411
320	-1	0.8	1.3033634023181904
321	1	0.6818181818181819	2.3262272190116065
322	1	0.7857142857142857	2.800458450255612
323	-1	0.7	0.841883775521149
324	1	0.7	1.554147196706578
325	-1	0.7	1.6517317382919425
326	1	0.8	2.8577606484499984
327	1	0.7	2.0130740959043703
328	1	0.7222222222222222	1.1669670638150411
329	1	0.7222222222222222	2.853748594761342
330	-1	0.7	1.3140687983379553
331	1	0.8	2.3988337492522067
332	1	0.7	1.4479148183803512
333	1	0.7	2.373258709287195
334	1	0.8	2.875481330217898
335	-1	0.8	0.9594940111230175
336	-1	0.7	0.5114037390625237
337	1	0.7222222222222222	2.853748594761342
338	1	0.7222222222222222	2.07075717716617
339	-1	0.8	0.7895522613187869
340	1	0.7	1.4479148183803512
341	-1	0.7	1.4401061860014908
342	1	0.8	1.4995754165223207
343	1	0.7222222222222222	2.3206462296464863
344	-1	0.7	1.2663946211710717
345	1	0.8	1.9553028676935162
346	-1	0.7	1.5979057098681282
347	1	0.8	2.875481330217898
348	0	0.6	1.7589364211497365
349	1	0.8	2.6964374274897103
350	1	0.7222222222222222	2.4596577754882127
351	1	0.8	2.875481330217898
352	1	0.7	1.6622979213957407
353	1	0.7222222222222222	1.621652282931774
354	1	0.7222222222222222	2.918584674686005
355	-1	0.7	1.3000095219519443
356	1	0.7222222222222222	2.097395707736926
357	-1	0.8	0.8444365031203982
358	1	0.7	2.564582481875393
359	1	0.7	1.4479148183803512
360	1	0.7857142857142857	2.3415315510578196
361	1	0.7	0.988987919182559
362	1	0.7	2.580151719791325
363	-1	0.7	0.3829568763233569
364	1	0.7222222222222222	2.3206462296464863
365	1	0.7857142857142857	2.3415315510578196
366	-1	0.75	1.5638117977524058
367	1	0.8	1.4995754165223207
368	1	0.8	2.8577606484499984
369	0	0.6	1.7589364211497365
370	1	0.8	2.6964374274897103
371	1	0.8	2.875481330217898
372	-1	0.8	0.9594940111230175
373	-1	0.7	0.9811792868036988
374	-1	0.8	0.9517788988929208
375	1	0.8	2.875481330217898
376	1	0.75	2.6084349816533683
377	-1	0.8	0.9594940111230175
378	-1	0.75	1.5025084931741168
379	1	0.7222222222222222	2.7010846918615368
380	1	0.75	2.6084349816533683
381	1	0.7222222222222222	1.621652282931774
382	-1	0.7	1.6517317382919425
383	1	0.7	1.914331810089403
384	1	0.7222222222222222	1.625893963012833
385	-1	0.7	1.3000095219519443
386	1	0.7	2.3113658522967837
387	1	0.7222222222222222	2.242157792663745
388	1	0.7	2.0557207901147976
389	1	0.7	2.580151719791325
390	-1	0.7	1.3140687983379553
391	1	0.7222222222222222	2.242157792663745
392	-1	0.7	1.2349131097800807
393	-1	0.8	0.9594940111230175
394	0	0.6	2.020956422334746
395	-1	0.8	1.248479160516579
396	1	0.7222222222222222	2.242157792663745
397	1	0.7	2.5779927997312324
398	1	0.8	2.2375105282919185
399	1	0.7	1.914331810089403
400	1	0.7222222222222222	2.5563226069347182
401	-1	0.8	1.5698976981733792
402	-1	0.7	1.2594529619272483
403	1	0.6666666666666666	1.9380770481158835
404	-1	0.75	1.5638117977524058
405	-1	0.75	1.0435815939763249
406	-1	0.75	1.1048848985546138
407	1	0.7	2.564582481875393
408	1	0.7222222222222222	1.621652282931774
409	1	0.6818181818181819	2.3262272190116065
410	1	0.75	2.1495080824555766
411	1	0.7	2.564582481875393
412	0	0.6	2.1190659005334407
413	-1	0.8	1.4184209103208096
414	1	0.7222222222222222	2.853748594761342
415	-1	0.8	1.5342978641353873
416	-1	0.8	0.9594940111230175
417	1	0.7	2.50443679105879
418	-1	0.8	1.0753709649375953
419	-1	0.8	1.5698976981733792
420	1	0.75	2.1495080824555766
421	1	0.7	2.6585411990597736
422	1	0.7	2.1056555826776013
423	-1	0.7	1.5979057098681282
424	-1	0.7	1.4401061860014908
425	0	0.6	1.7589364211497365
426	1	0.7	2.569585536687527
427	-1	0.7	1.4401061860014908
428	-1	0.7	1.2594529619272483
429	1	0.8	1.496375968495724
430	1	0.8	2.2375105282919185
431	-1	0.75	1.0435815939763249
432	1	0.8	2.417429214917905
433	1	0.7	2.4720009951021624
434	-1	0.7	1.138978810670336
435	1	0.7222222222222222	1.621652282931774
436	1	0.8	1.958502315720113
437	1	0.8	2.875481330217898
438	1	0.7222222222222222	2.5563226069347182
439	1	0.7222222222222222	2.7010846918615368
440	-1	0.7	0.9703306382603157
441	-1	0.7	1.6517317382919425
442	-1	0.7	0.841883775521149
443	1	0.8	2.875481330217898
444	1	0.7	2.7702927514945754
445	-1	0.75	1.1048848985546138
446	-1	0.75	1.5025084931741168
447	1	0.7222222222222222	2.918584674686005
448	1	0.7	2.5592550191037313
449	1	0.7857142857142857	2.800458450255612
450	-1	0.75	1.5025084931741168
451	-1	0.7	0.5114037390625237
452	1	0.7857142857142857	2.800458450255612
453	1	0.7222222222222222	2.529684076363962
454	0	0.6	2.1106586374897347
455	1	0.7	1.914331810089403
456	1	0.7222222222222222	2.918584674686005
457	-1	0.8	0.4928519996951288
458	1	0.7	2.50443679105879
459	1	0.7222222222222222	2.242157792663745
460	1	0.75	2.1495080824555766
461	1	0.7	2.1056555826776013
462	-1	0.7	1.6601390013356485
463	1	0.7	1.554147196706578
464	-1	0.75	1.5025084931741168
465	0	0.6	2.020956422334746
466	1	0.6818181818181819	2.785154118209398
467	1	0.75	2.1495080824555766
468	1	0.7	0.988987919182559
469	1	0.7	1.5967938909170059
470	1	0.8	1.9553028676935162
471	1	0.7222222222222222	2.918584674686005
472	-1	0.7	1.2349131097800807
473	-1	0.8	1.248479160516579
474	1	0.7222222222222222	1.625893963012833
475	1	0.7	1.641401220708147
476	-1	0.7	1.5979057098681282
477	-1	0.8	1.5698976981733792
478	1	0.8	3.33440822941569
479	1	0.6818181818181819	2.1555351107733665
480	1	0.7	2.1003281199059387
481	-1	0.75	1.5638117977524058
482	1	0.7	0.988987919182559
483	-1	0.8	0.9517788988929208
484	0	0.6	2.1106586374897347
485	-1	0.8	1.248479160516579
486	-1	0.75	1.0435815939763249
487	0	0.6	2.020956422334746
488	-1	0.8	1.110970798975587
489	1	0.6818181818181819	2.6144620099711586
490	1	0.7222222222222222	1.1669670638150411
491	1	0.7	1.554147196706578
492	1	0.7	1.554147196706578
493	-1	0.7	0.3829568763233569
494	0	0.6	2.1996142998619814
495	1	0.7222222222222222	2.4596577754882127
496	1	0.7222222222222222	1.625893963012833
497	1	0.7857142857142857	2.800458450255612
498	1	0.7222222222222222	2.4596577754882127
499	1	0.6818181818181819	1.6966082115755745
500	-1	0.8	1.248479160516579
501	1	0.6818181818181819	2.3262272190116065
502	-1	0.8	0.9517788988929208
503	1	0.7	2.5592550191037313
504	1	0.8	2.417429214917905
505	-1	0.7	1.2349131097800807
506	-1	0.75	1.0435815939763249
507	-1	0.8	1.248479160516579
508	1	0.7222222222222222	2.529684076363962
509	1	0.7	2.963363690256582
510	1	0.7222222222222222	2.242157792663745
511	-1	0.7	1.138978810670336
512	1	0.7222222222222222	2.07075717716617
513	0	0.6	2.1996142998619814
514	1	0.7222222222222222	2.5395060813273584
515	1	0.7	2.5592550191037313
516	1	0.7222222222222222	2.242157792663745
517	1	0.7	2.184248419566656
518	1	0.7222222222222222	2.779573128844278
519	1	0.6818181818181819	2.785154118209398
520	1	0.7	1.554147196706578
521	-1	0.7	1.6601390013356485
522	-1	0.8	0.8444365031203982
523	-1	0.7	1.2594529619272483
524	-1	0.7	1.2663946211710717
525	1	0.7222222222222222	2.5563226069347182
526	-1	0.7	1.3140687983379553
527	-1	0.7	0.5114037390625237
528	1	0.8	2.875481330217898
529	1	0.7222222222222222	2.529684076363962
530	1	0.8	2.6964374274897103
531	1	0.6818181818181819	2.6144620099711586
532	1	0.7222222222222222	2.918584674686005
533	1	0.7222222222222222	2.7010846918615368
534	-1	0.8	1.3033634023181904
535	-1	0.7	1.138978810670336
536	1	0.7222222222222222	2.779573128844278
537	-1	0.7	1.2663946211710717
538	1	0.7	2.184248419566656
539	-1	0.8	1.5698976981733792
540	1	0.8	2.3913164219827783
541	1	0.7222222222222222	2.3206462296464863
542	1	0.6818181818181819	2.3262272190116065
543	-1	0.7	0.9811792868036988
544	-1	0.7	0.5114037390625237
545	1	0.7	1.0713559741671757
546	1	0.7857142857142857	2.800458450255612
547	1	0.6818181818181819	2.6144620099711586
548	-1	0.8	1.0753709649375953
549	0	0.6	1.7253215203688637
550	1	0.8	1.9553028676935162
551	1	0.7	2.569585536687527
552	-1	0.7	0.5114037390625237
553	-1	0.7	1.2594529619272483
554	-1	0.75	1.5025084931741168
555	1	0.7	2.580151719791325
556	1	0.7	2.1056555826776013
557	1	0.8	2.3913164219827783
558	-1	0.7	1.2663946211710717
559	1	0.7	2.7702927514945754
560	-1	0.8	1.248479160516579
561	0	0.6	2.1996142998619814
562	1	0.8	2.417429214917905
563	1	0.6818181818181819	2.785154118209398
564	1	0.8	1.4995754165223207
565	0	0.6	1.7589364211497365
566	1	0.7222222222222222	2.3206462296464863
567	1	0.8	3.33440822941569
568	-1	0.7	0.3829568763233569
569	1	0.8	2.2375105282919185
570	1	0.7	1.4479148183803512
571	0	0.6	2.020956422334746
572	1	0.7222222222222222	2.529684076363962
573	1	0.7	2.1056555826776013
574	1	0.8	2.3988337492522067
575	1	0.7857142857142857	2.800458450255612
576	1	0.8	2.414229766891308
577	1	0.8	1.9553028676935162
578	1	0.6818181818181819	2.6144620099711586
579	-1	0.7	1.6517317382919425
580	0	0.6	2.1190659005334407
581	1	0.7	1.5967938909170059
582	1	0.7	1.4479148183803512
583	1	0.7	2.121224820593533
584	-1	0.7	1.138978810670336
585	1	0.7	1.5302828733649676
586	1	0.7	2.580151719791325
587	1	0.75	2.6084349816533683
588	1	0.7	2.4720009951021624
589	1	0.7	1.914331810089403
590	1	0.7	2.0130740959043703
591	-1	0.75	1.1048848985546138
592	1	0.8	2.3988337492522067
593	1	0.8	2.2375105282919185
594	-1	0.7	1.3140687983379553
595	-1	0.7	0.9811792868036988
596	1	0.7	2.1056555826776013
597	-1	0.7	0.841883775521149
598	1	0.6666666666666666	1.9380770481158835
599	-1	0.8	1.248479160516579
600	1	0.7	0.988987919182559
601	1	0.6818181818181819	2.785154118209398
602	1	0.7222222222222222	2.4596577754882127
603	1	0.6818181818181819	1.6966082115755745
604	1	0.7	1.6622979213957407
605	1	0.7	2.564582481875393
606	1	0.8	2.85024332118057
607	-1	0.8	1.5698976981733792
608	1	0.8	2.3913164219827783
609	1	0.8	2.6964374274897103
610	-1	0.8	1.110970798975587
611	-1	0.7	1.7406874006641893
612	1	0.7222222222222222	2.529684076363962
613	-1	0.7	0.841883775521149
614	1	0.6818181818181819	2.785154118209398
615	1	0.7	2.1003281199059387
616	-1	0.8	1.110970798975587
617	1	0.7	1.5302828733649676
618	1	0.7222222222222222	2.853748594761342
619	1	0.7	2.0557207901147976
620	-1	0.7	0.9703306382603157
621	1	0.7	2.121224820593533
622	-1	0.7	1.5979057098681282
623	1	0.7	2.2178633203475284
624	-1	0.8	1.3033634023181904
625	1	0.7	2.50443679105879
626	-1	0.7	0.7759862105822887
627	1	0.7222222222222222	2.529684076363962
628	1	0.7	2.6585411990597736
629	-1	0.8	1.248479160516579
630	1	0.8	2.2375105282919185
631	1	0.7222222222222222	2.07075717716617
632	1	0.8	2.85024332118057
633	1	0.7	2.4720009951021624
634	1	0.8	1.3287056118016025
635	1	0.7857142857142857	2.3415315510578196
636	1	0.6666666666666666	1.4791501489180916
637	1	0.7222222222222222	2.080579182129566
638	1	0.8	1.3287056118016025
639	1	0.7	2.50443679105879
640	1	0.8	2.3988337492522067
641	1	0.7	2.1003281199059387
642	1	0.8	1.4995754165223207
643	-1	0.8	1.5342978641353873
644	1	0.7	1.641401220708147
645	1	0.8	2.85024332118057
646	0	0.6	1.7253215203688637
647	1	0.7222222222222222	1.621652282931774
648	-1	0.7	0.841883775521149
649	-1	0.8	1.3033634023181904
650	1	0.8	1.3287056118016025
651	-1	0.7	1.2594529619272483
\.


--
-- TOC entry 5404 (class 0 OID 46234)
-- Dependencies: 286
-- Data for Name: review_sentiment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_sentiment (id, sentiment_score) FROM stdin;
1	0.01565730571746826
2	-0.22336655855178833
3	-0.2302531599998474
4	-0.08035546541213989
5	-0.2614460289478302
6	-0.22973287105560303
7	-0.2251230776309967
8	-0.2302531599998474
9	-0.027439415454864502
10	0.2148745059967041
11	-0.24035793542861938
12	-0.1932215392589569
13	-0.2251230776309967
14	-0.234431654214859
15	-0.07053166627883911
16	-0.1971898376941681
17	-0.16187646985054016
18	-0.24309077858924866
19	-0.1971898376941681
20	-0.1408213973045349
21	-0.08035546541213989
22	-0.24035793542861938
23	-0.24035793542861938
24	-0.2614460289478302
25	-0.2232581377029419
26	-0.22322699427604675
27	-0.08035546541213989
28	-0.08035546541213989
29	-0.234431654214859
30	-0.21786314249038696
31	-0.234431654214859
32	-0.2354539930820465
33	-0.23834067583084106
34	-0.16336306929588318
35	-0.23834067583084106
36	-0.05608457326889038
37	-0.22973287105560303
38	-0.08035546541213989
39	-0.2354539930820465
40	-0.16187646985054016
41	-0.22464260458946228
42	-0.22464260458946228
43	-0.07053166627883911
44	-0.22322699427604675
45	-0.234431654214859
46	-0.2490193247795105
47	-0.2614460289478302
48	-0.21786314249038696
49	-0.2302531599998474
50	-0.1971898376941681
51	-0.1971898376941681
52	-0.2354539930820465
53	-0.22973287105560303
54	-0.2097502052783966
55	-0.222660094499588
56	-0.24309077858924866
57	-0.234431654214859
58	-0.2751220762729645
59	-0.16336306929588318
60	-0.2354539930820465
61	-0.2354539930820465
62	-0.1932215392589569
63	-0.027439415454864502
64	-0.05608457326889038
65	-0.2751220762729645
66	-0.222660094499588
67	-0.2614460289478302
68	-0.21786314249038696
69	-0.2232581377029419
70	-0.16187646985054016
71	-0.07053166627883911
72	-0.2751220762729645
73	-0.16336306929588318
74	-0.21786314249038696
75	-0.08035546541213989
76	-0.1408213973045349
77	-0.2251230776309967
78	-0.20834970474243164
79	-0.22336655855178833
80	-0.16336306929588318
81	-0.24309077858924866
82	-0.2354539930820465
83	-0.08035546541213989
84	0.2148745059967041
85	-0.16187646985054016
86	-0.222660094499588
87	0.2148745059967041
88	-0.24035793542861938
89	-0.24035793542861938
90	-0.2751220762729645
91	-0.2751220762729645
92	-0.22973287105560303
93	0.2148745059967041
94	-0.2097502052783966
95	-0.1932215392589569
96	-0.22336655855178833
97	-0.24309077858924866
98	-0.21786314249038696
99	-0.2251230776309967
100	-0.222660094499588
\.


--
-- TOC entry 5362 (class 0 OID 45362)
-- Dependencies: 244
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, booking_id, reviewer_id, reviewer_type, rating, comment, created_at, updated_at) FROM stdin;
1	50	33	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-09 11:06:02.361129	2025-06-08 11:06:02.361129
2	51	31	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-11 11:06:02.361129	2025-06-08 11:06:02.361129
3	52	1	user	4	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
4	53	35	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-06-01 11:06:02.361129	2025-06-08 11:06:02.361129
5	54	19	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
6	55	2	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-18 11:06:02.361129	2025-06-08 11:06:02.361129
7	56	50	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
8	57	35	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
9	58	26	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-22 11:06:02.361129	2025-06-08 11:06:02.361129
10	59	17	user	4	Very professional, highly recommend this service!	2025-06-05 11:06:02.361129	2025-06-08 11:06:02.361129
11	60	26	user	4	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-20 11:06:02.361129	2025-06-08 11:06:02.361129
12	61	35	user	2	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-10 11:06:02.361129	2025-06-08 11:06:02.361129
13	62	21	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-24 11:06:02.361129	2025-06-08 11:06:02.361129
14	63	30	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-15 11:06:02.361129	2025-06-08 11:06:02.361129
15	64	50	user	4	Amazing service, tasker rất chu đáo.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
16	65	11	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
17	66	11	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-25 11:06:02.361129	2025-06-08 11:06:02.361129
18	67	10	user	1	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-05-29 11:06:02.361129	2025-06-08 11:06:02.361129
19	68	50	user	5	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-19 11:06:02.361129	2025-06-08 11:06:02.361129
20	69	3	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
21	70	9	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-11 11:06:02.361129	2025-06-08 11:06:02.361129
22	71	27	user	4	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-06-02 11:06:02.361129	2025-06-08 11:06:02.361129
23	72	46	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-25 11:06:02.361129	2025-06-08 11:06:02.361129
24	73	27	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
25	74	18	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-25 11:06:02.361129	2025-06-08 11:06:02.361129
26	75	1	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
27	76	4	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-18 11:06:02.361129	2025-06-08 11:06:02.361129
28	77	49	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-30 11:06:02.361129	2025-06-08 11:06:02.361129
29	78	19	user	3	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-30 11:06:02.361129	2025-06-08 11:06:02.361129
30	79	26	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-14 11:06:02.361129	2025-06-08 11:06:02.361129
31	80	2	user	3	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-30 11:06:02.361129	2025-06-08 11:06:02.361129
32	81	29	user	4	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-07 11:06:02.361129	2025-06-08 11:06:02.361129
33	82	38	user	4	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
34	83	36	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-21 11:06:02.361129	2025-06-08 11:06:02.361129
35	84	19	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-06-06 11:06:02.361129	2025-06-08 11:06:02.361129
36	85	3	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
37	86	3	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
38	87	19	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-23 11:06:02.361129	2025-06-08 11:06:02.361129
39	88	32	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-23 11:06:02.361129	2025-06-08 11:06:02.361129
40	89	32	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-20 11:06:02.361129	2025-06-08 11:06:02.361129
41	90	45	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-31 11:06:02.361129	2025-06-08 11:06:02.361129
42	91	48	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-06-08 11:06:02.361129	2025-06-08 11:06:02.361129
43	92	37	user	5	Amazing service, tasker rất chu đáo.	2025-06-05 11:06:02.361129	2025-06-08 11:06:02.361129
44	93	28	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-25 11:06:02.361129	2025-06-08 11:06:02.361129
45	94	14	user	3	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-06-01 11:06:02.361129	2025-06-08 11:06:02.361129
46	95	18	user	3	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-06-06 11:06:02.361129	2025-06-08 11:06:02.361129
47	96	34	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-06-07 11:06:02.361129	2025-06-08 11:06:02.361129
48	97	42	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-06-08 11:06:02.361129	2025-06-08 11:06:02.361129
49	98	20	user	4	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-28 11:06:02.361129	2025-06-08 11:06:02.361129
50	99	46	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-21 11:06:02.361129	2025-06-08 11:06:02.361129
51	100	45	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-06-02 11:06:02.361129	2025-06-08 11:06:02.361129
52	101	12	user	3	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
53	102	48	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
54	103	40	user	1	Tasker làm ẩu, không đáng để book lại.	2025-05-10 11:06:02.361129	2025-06-08 11:06:02.361129
55	104	29	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-29 11:06:02.361129	2025-06-08 11:06:02.361129
56	105	48	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-05-31 11:06:02.361129	2025-06-08 11:06:02.361129
57	106	26	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-22 11:06:02.361129	2025-06-08 11:06:02.361129
58	107	28	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-17 11:06:02.361129	2025-06-08 11:06:02.361129
59	108	35	user	2	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
60	109	34	user	4	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-25 11:06:02.361129	2025-06-08 11:06:02.361129
61	110	43	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-08 11:06:02.361129	2025-06-08 11:06:02.361129
62	111	45	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
63	112	20	user	5	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-15 11:06:02.361129	2025-06-08 11:06:02.361129
64	113	16	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-06-03 11:06:02.361129	2025-06-08 11:06:02.361129
65	114	9	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-06-01 11:06:02.361129	2025-06-08 11:06:02.361129
66	115	8	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-09 11:06:02.361129	2025-06-08 11:06:02.361129
67	116	24	user	2	Không hài lòng, công việc không đúng như kỳ vọng.	2025-06-03 11:06:02.361129	2025-06-08 11:06:02.361129
68	117	16	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-30 11:06:02.361129	2025-06-08 11:06:02.361129
69	118	1	user	2	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-26 11:06:02.361129	2025-06-08 11:06:02.361129
70	119	40	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
71	120	21	user	5	Amazing service, tasker rất chu đáo.	2025-05-23 11:06:02.361129	2025-06-08 11:06:02.361129
72	121	14	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-17 11:06:02.361129	2025-06-08 11:06:02.361129
73	122	18	user	2	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-09 11:06:02.361129	2025-06-08 11:06:02.361129
74	123	32	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
75	124	43	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-06-04 11:06:02.361129	2025-06-08 11:06:02.361129
76	125	19	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-05-24 11:06:02.361129	2025-06-08 11:06:02.361129
77	126	43	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-06-02 11:06:02.361129	2025-06-08 11:06:02.361129
78	127	31	user	2	Very unprofessional, không đáng giá tiền.	2025-06-01 11:06:02.361129	2025-06-08 11:06:02.361129
79	128	2	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
80	129	42	user	2	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-23 11:06:02.361129	2025-06-08 11:06:02.361129
81	130	48	user	1	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-05-19 11:06:02.361129	2025-06-08 11:06:02.361129
82	131	39	user	4	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-06 11:06:02.361129	2025-06-08 11:06:02.361129
83	132	41	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-14 11:06:02.361129	2025-06-08 11:06:02.361129
84	133	20	user	4	Very professional, highly recommend this service!	2025-06-03 11:06:02.361129	2025-06-08 11:06:02.361129
85	134	30	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-06-04 11:06:02.361129	2025-06-08 11:06:02.361129
86	135	11	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-18 11:06:02.361129	2025-06-08 11:06:02.361129
87	136	38	user	5	Very professional, highly recommend this service!	2025-05-13 11:06:02.361129	2025-06-08 11:06:02.361129
88	137	48	user	2	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-14 11:06:02.361129	2025-06-08 11:06:02.361129
89	138	26	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-06-05 11:06:02.361129	2025-06-08 11:06:02.361129
90	139	11	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-06-06 11:06:02.361129	2025-06-08 11:06:02.361129
91	140	9	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-27 11:06:02.361129	2025-06-08 11:06:02.361129
92	141	12	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-11 11:06:02.361129	2025-06-08 11:06:02.361129
93	142	27	user	4	Very professional, highly recommend this service!	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
94	143	8	user	1	Tasker làm ẩu, không đáng để book lại.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
95	144	10	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-16 11:06:02.361129	2025-06-08 11:06:02.361129
96	145	9	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-31 11:06:02.361129	2025-06-08 11:06:02.361129
97	146	3	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-06-04 11:06:02.361129	2025-06-08 11:06:02.361129
98	147	37	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-06-07 11:06:02.361129	2025-06-08 11:06:02.361129
99	148	44	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-05-12 11:06:02.361129	2025-06-08 11:06:02.361129
100	149	34	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-06-05 11:06:02.361129	2025-06-08 11:06:02.361129
152	151	31	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-21 23:05:47.887856	2025-06-08 23:05:47.887856
153	152	46	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-10 23:05:47.887856	2025-06-08 23:05:47.887856
154	153	25	user	3	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-13 23:05:47.887856	2025-06-08 23:05:47.887856
155	154	38	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-24 23:05:47.887856	2025-06-08 23:05:47.887856
156	155	30	user	2	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-17 23:05:47.887856	2025-06-08 23:05:47.887856
157	156	8	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-13 23:05:47.887856	2025-06-08 23:05:47.887856
158	157	39	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-11 23:05:47.887856	2025-06-08 23:05:47.887856
159	158	40	user	4	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-23 23:05:47.887856	2025-06-08 23:05:47.887856
160	159	19	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-15 23:05:47.887856	2025-06-08 23:05:47.887856
161	160	25	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-20 23:05:47.887856	2025-06-08 23:05:47.887856
162	161	14	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-06-08 23:05:47.887856	2025-06-08 23:05:47.887856
163	162	16	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-24 23:05:47.887856	2025-06-08 23:05:47.887856
164	163	41	user	2	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-06-03 23:05:47.887856	2025-06-08 23:05:47.887856
165	164	7	user	2	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-23 23:05:47.887856	2025-06-08 23:05:47.887856
166	165	12	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-09 23:05:47.887856	2025-06-08 23:05:47.887856
167	166	44	user	5	Very professional, highly recommend this service!	2025-05-27 23:05:47.887856	2025-06-08 23:05:47.887856
168	167	31	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-06-04 23:05:47.887856	2025-06-08 23:05:47.887856
169	168	20	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-06-06 23:05:47.887856	2025-06-08 23:05:47.887856
170	169	17	user	4	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-12 23:05:47.887856	2025-06-08 23:05:47.887856
171	170	44	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-05-28 23:05:47.887856	2025-06-08 23:05:47.887856
172	171	25	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-31 23:05:47.887856	2025-06-08 23:05:47.887856
173	172	29	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-10 23:05:47.887856	2025-06-08 23:05:47.887856
174	173	31	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-05-24 23:05:47.887856	2025-06-08 23:05:47.887856
175	174	21	user	1	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-30 23:05:47.887856	2025-06-08 23:05:47.887856
176	175	17	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-17 23:05:47.887856	2025-06-08 23:05:47.887856
177	176	27	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-06-02 23:05:47.887856	2025-06-08 23:05:47.887856
178	177	36	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-21 23:05:47.887856	2025-06-08 23:05:47.887856
179	178	28	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-29 23:05:47.887856	2025-06-08 23:05:47.887856
180	179	44	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-28 23:05:47.887856	2025-06-08 23:05:47.887856
181	180	24	user	4	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-31 23:05:47.887856	2025-06-08 23:05:47.887856
182	181	47	user	3	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-24 23:05:47.887856	2025-06-08 23:05:47.887856
183	182	40	user	4	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-16 23:05:47.887856	2025-06-08 23:05:47.887856
184	183	9	user	1	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-31 23:05:47.887856	2025-06-08 23:05:47.887856
185	184	27	user	2	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-06-08 23:05:47.887856	2025-06-08 23:05:47.887856
186	185	28	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-13 23:05:47.887856	2025-06-08 23:05:47.887856
187	186	5	user	3	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-20 23:05:47.887856	2025-06-08 23:05:47.887856
188	187	38	user	3	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-21 23:05:47.887856	2025-06-08 23:05:47.887856
189	188	43	user	4	Dịch vụ bình thường, không có gì nổi bật.	2025-05-12 23:05:47.887856	2025-06-08 23:05:47.887856
190	189	46	user	2	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-06-04 23:05:47.887856	2025-06-08 23:05:47.888882
191	190	37	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-06-08 23:05:47.888882	2025-06-08 23:05:47.888882
192	191	27	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-31 23:05:47.888882	2025-06-08 23:05:47.888882
193	192	15	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-06-07 23:05:47.888882	2025-06-08 23:05:47.888882
194	193	17	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
195	194	13	user	1	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
196	195	24	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-28 23:05:47.888882	2025-06-08 23:05:47.888882
197	196	7	user	4	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-06-04 23:05:47.888882	2025-06-08 23:05:47.888882
198	197	30	user	2	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
199	198	9	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-06-08 23:05:47.888882	2025-06-08 23:05:47.888882
200	199	13	user	2	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-12 23:05:47.888882	2025-06-08 23:05:47.888882
201	200	43	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-31 23:05:47.888882	2025-06-08 23:05:47.888882
202	201	34	user	4	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
203	202	16	user	1	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-06-07 23:05:47.888882	2025-06-08 23:05:47.888882
204	203	47	user	4	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
205	204	41	user	5	Very professional, highly recommend this service!	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
206	205	37	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
207	206	15	user	3	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
208	207	13	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-19 23:05:47.888882	2025-06-08 23:05:47.888882
209	208	21	user	1	Very unprofessional, không đáng giá tiền.	2025-06-02 23:05:47.888882	2025-06-08 23:05:47.888882
210	209	9	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
211	210	24	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
212	211	7	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-30 23:05:47.888882	2025-06-08 23:05:47.888882
213	212	18	user	4	Very professional, highly recommend this service!	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
214	213	48	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-06-02 23:05:47.888882	2025-06-08 23:05:47.888882
215	214	21	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
216	215	40	user	2	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-06-03 23:05:47.888882	2025-06-08 23:05:47.888882
217	216	7	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
218	217	18	user	2	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
219	218	14	user	3	Dịch vụ bình thường, không có gì nổi bật.	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
220	219	9	user	4	Very professional, highly recommend this service!	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
221	220	6	user	1	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-16 23:05:47.888882	2025-06-08 23:05:47.888882
222	221	1	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
223	222	25	user	5	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-06-04 23:05:47.888882	2025-06-08 23:05:47.888882
224	223	38	user	4	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
225	224	27	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-30 23:05:47.888882	2025-06-08 23:05:47.888882
226	225	35	user	3	Dịch vụ bình thường, không có gì nổi bật.	2025-05-09 23:05:47.888882	2025-06-08 23:05:47.888882
227	226	46	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-29 23:05:47.888882	2025-06-08 23:05:47.888882
228	227	47	user	5	Amazing service, tasker rất chu đáo.	2025-05-25 23:05:47.888882	2025-06-08 23:05:47.888882
229	228	2	user	3	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
230	229	35	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
231	230	1	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-27 23:05:47.888882	2025-06-08 23:05:47.888882
232	231	17	user	4	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-27 23:05:47.888882	2025-06-08 23:05:47.888882
233	232	42	user	3	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
234	233	6	user	4	Amazing service, tasker rất chu đáo.	2025-05-16 23:05:47.888882	2025-06-08 23:05:47.888882
235	234	24	user	5	Amazing service, tasker rất chu đáo.	2025-05-29 23:05:47.888882	2025-06-08 23:05:47.888882
236	235	4	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-16 23:05:47.888882	2025-06-08 23:05:47.888882
237	236	28	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
238	237	36	user	4	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
239	238	33	user	3	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-14 23:05:47.888882	2025-06-08 23:05:47.888882
240	239	24	user	1	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
241	240	47	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
242	241	36	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
243	242	49	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-25 23:05:47.888882	2025-06-08 23:05:47.888882
244	243	9	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
245	244	42	user	1	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
246	245	17	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
247	246	2	user	1	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
248	247	18	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
249	248	38	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-12 23:05:47.888882	2025-06-08 23:05:47.888882
250	249	20	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-27 23:05:47.888882	2025-06-08 23:05:47.888882
251	250	16	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-27 23:05:47.888882	2025-06-08 23:05:47.888882
252	251	23	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-30 23:05:47.888882	2025-06-08 23:05:47.888882
253	252	24	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
254	253	1	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-09 23:05:47.888882	2025-06-08 23:05:47.888882
255	254	37	user	5	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-05-12 23:05:47.888882	2025-06-08 23:05:47.888882
256	255	43	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-09 23:05:47.888882	2025-06-08 23:05:47.888882
257	256	23	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-21 23:05:47.888882	2025-06-08 23:05:47.888882
258	257	39	user	5	Very professional, highly recommend this service!	2025-05-24 23:05:47.888882	2025-06-08 23:05:47.888882
259	258	38	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
260	259	31	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-06-07 23:05:47.888882	2025-06-08 23:05:47.888882
261	260	7	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-25 23:05:47.888882	2025-06-08 23:05:47.888882
262	261	9	user	4	Very professional, highly recommend this service!	2025-05-19 23:05:47.888882	2025-06-08 23:05:47.888882
263	262	30	user	4	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-19 23:05:47.888882	2025-06-08 23:05:47.888882
264	263	39	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
265	264	11	user	2	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
266	265	32	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
267	266	32	user	2	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
268	267	47	user	4	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
269	268	44	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-21 23:05:47.888882	2025-06-08 23:05:47.888882
270	269	9	user	3	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
271	270	8	user	5	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-06-01 23:05:47.888882	2025-06-08 23:05:47.888882
272	271	37	user	1	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
273	272	3	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-22 23:05:47.888882	2025-06-08 23:05:47.888882
274	273	19	user	1	Tasker làm việc cẩu thả, không đáng tiền.	2025-05-09 23:05:47.888882	2025-06-08 23:05:47.888882
275	274	36	user	2	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-06-02 23:05:47.888882	2025-06-08 23:05:47.888882
276	275	50	user	1	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
277	276	6	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
278	277	47	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-17 23:05:47.888882	2025-06-08 23:05:47.888882
279	278	23	user	2	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
280	279	7	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
281	280	12	user	3	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
282	281	11	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
283	282	23	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-06-03 23:05:47.888882	2025-06-08 23:05:47.888882
284	283	49	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
285	284	18	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-06-07 23:05:47.888882	2025-06-08 23:05:47.888882
286	285	36	user	4	Dịch vụ bình thường, không có gì nổi bật.	2025-06-03 23:05:47.888882	2025-06-08 23:05:47.888882
287	286	22	user	2	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-25 23:05:47.888882	2025-06-08 23:05:47.888882
288	287	42	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
289	288	16	user	2	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
290	289	2	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
291	290	41	user	2	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-05-10 23:05:47.888882	2025-06-08 23:05:47.888882
292	291	22	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-15 23:05:47.888882	2025-06-08 23:05:47.888882
293	292	23	user	4	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-05-24 23:05:47.888882	2025-06-08 23:05:47.888882
294	293	2	user	4	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
295	294	9	user	2	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-05-09 23:05:47.888882	2025-06-08 23:05:47.888882
296	295	24	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
297	296	4	user	4	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-06-03 23:05:47.888882	2025-06-08 23:05:47.888882
298	297	8	user	5	Very professional, highly recommend this service!	2025-06-06 23:05:47.888882	2025-06-08 23:05:47.888882
299	298	3	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-06-02 23:05:47.888882	2025-06-08 23:05:47.888882
300	299	42	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-22 23:05:47.888882	2025-06-08 23:05:47.888882
301	300	11	user	2	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-29 23:05:47.888882	2025-06-08 23:05:47.888882
302	301	24	user	5	Amazing service, tasker rất chu đáo.	2025-05-21 23:05:47.888882	2025-06-08 23:05:47.888882
303	302	44	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-12 23:05:47.888882	2025-06-08 23:05:47.888882
304	303	20	user	5	Very professional, highly recommend this service!	2025-06-04 23:05:47.888882	2025-06-08 23:05:47.888882
305	304	13	user	1	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-16 23:05:47.888882	2025-06-08 23:05:47.888882
306	305	24	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-20 23:05:47.888882	2025-06-08 23:05:47.888882
307	306	4	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-06-06 23:05:47.888882	2025-06-08 23:05:47.888882
308	307	32	user	3	Dịch vụ bình thường, không có gì nổi bật.	2025-05-16 23:05:47.888882	2025-06-08 23:05:47.888882
309	308	2	user	3	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
310	309	16	user	1	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-28 23:05:47.888882	2025-06-08 23:05:47.888882
311	310	8	user	2	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-24 23:05:47.888882	2025-06-08 23:05:47.888882
312	311	37	user	4	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-21 23:05:47.888882	2025-06-08 23:05:47.888882
313	312	13	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-06-07 23:05:47.888882	2025-06-08 23:05:47.888882
314	313	2	user	2	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-26 23:05:47.888882	2025-06-08 23:05:47.888882
315	314	39	user	1	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
316	315	25	user	2	Tasker làm việc cẩu thả, không đáng tiền.	2025-06-01 23:05:47.888882	2025-06-08 23:05:47.888882
317	316	8	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-21 23:05:47.888882	2025-06-08 23:05:47.888882
318	317	42	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-31 23:05:47.888882	2025-06-08 23:05:47.888882
319	318	43	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
320	319	4	user	2	Very unprofessional, không đáng giá tiền.	2025-06-05 23:05:47.888882	2025-06-08 23:05:47.888882
321	320	16	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-13 23:05:47.888882	2025-06-08 23:05:47.888882
322	321	50	user	5	Amazing service, tasker rất chu đáo.	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
323	322	25	user	2	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-06-08 23:05:47.888882	2025-06-08 23:05:47.888882
324	323	10	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
325	324	42	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-06-02 23:05:47.888882	2025-06-08 23:05:47.888882
326	325	36	user	5	Very professional, highly recommend this service!	2025-05-11 23:05:47.888882	2025-06-08 23:05:47.888882
327	326	8	user	3	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-06-03 23:05:47.888882	2025-06-08 23:05:47.888882
328	327	16	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-06-04 23:05:47.888882	2025-06-08 23:05:47.888882
329	328	11	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-06-04 23:05:47.888882	2025-06-08 23:05:47.888882
330	329	35	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-22 23:05:47.888882	2025-06-08 23:05:47.888882
331	330	50	user	4	Very professional, highly recommend this service!	2025-05-18 23:05:47.888882	2025-06-08 23:05:47.888882
332	331	36	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-23 23:05:47.888882	2025-06-08 23:05:47.888882
333	332	11	user	4	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-05-22 23:05:47.888882	2025-06-08 23:05:47.888882
334	333	14	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-30 23:05:47.888882	2025-06-08 23:05:47.888882
335	334	3	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-14 23:05:47.888882	2025-06-08 23:05:47.888882
336	335	14	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
337	336	27	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
338	337	41	user	4	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-23 23:05:47.889874	2025-06-08 23:05:47.889874
339	338	48	user	1	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-06-03 23:05:47.889874	2025-06-08 23:05:47.889874
340	339	21	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
341	340	44	user	2	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-06-05 23:05:47.889874	2025-06-08 23:05:47.889874
342	341	21	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
343	342	29	user	4	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-11 23:05:47.889874	2025-06-08 23:05:47.889874
344	343	41	user	2	Dịch vụ bình thường, không có gì nổi bật.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
345	344	36	user	3	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-20 23:05:47.889874	2025-06-08 23:05:47.889874
346	345	30	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-06-06 23:05:47.889874	2025-06-08 23:05:47.889874
347	346	39	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
348	347	39	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
349	348	33	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
350	349	4	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
351	350	1	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
352	351	40	user	2	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-06-06 23:05:47.889874	2025-06-08 23:05:47.889874
353	352	44	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
354	353	12	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-06-05 23:05:47.889874	2025-06-08 23:05:47.889874
355	354	24	user	2	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
356	355	47	user	4	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
357	356	27	user	1	Very unprofessional, không đáng giá tiền.	2025-06-02 23:05:47.889874	2025-06-08 23:05:47.889874
358	357	16	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
359	358	39	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
360	359	9	user	4	Amazing service, tasker rất chu đáo.	2025-05-11 23:05:47.889874	2025-06-08 23:05:47.889874
361	360	33	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-06-02 23:05:47.889874	2025-06-08 23:05:47.889874
362	361	50	user	4	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
363	362	24	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
364	363	42	user	4	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-22 23:05:47.889874	2025-06-08 23:05:47.889874
365	364	43	user	4	Amazing service, tasker rất chu đáo.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
366	365	15	user	2	Tasker làm việc cẩu thả, không đáng tiền.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
367	366	15	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
368	367	15	user	5	Very professional, highly recommend this service!	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
369	368	32	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
370	369	15	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
371	370	3	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
372	371	48	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
373	372	30	user	1	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
374	373	29	user	2	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
375	374	41	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-30 23:05:47.889874	2025-06-08 23:05:47.889874
376	375	14	user	5	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-21 23:05:47.889874	2025-06-08 23:05:47.889874
377	376	34	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-26 23:05:47.889874	2025-06-08 23:05:47.889874
378	377	25	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-06-06 23:05:47.889874	2025-06-08 23:05:47.889874
379	378	24	user	5	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-11 23:05:47.889874	2025-06-08 23:05:47.889874
380	379	40	user	5	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
381	380	30	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-05 23:05:47.889874	2025-06-08 23:05:47.889874
382	381	35	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
383	382	13	user	3	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
384	383	15	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
385	384	16	user	2	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
386	385	15	user	4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
387	386	41	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
388	387	1	user	3	Very good, nhưng có vài điểm cần cải thiện.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
389	388	50	user	4	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
390	389	8	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
391	390	5	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
392	391	39	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
393	392	31	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
394	393	44	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
395	394	42	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
396	395	22	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
397	396	45	user	4	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
398	397	48	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
399	398	1	user	3	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-06-06 23:05:47.889874	2025-06-08 23:05:47.889874
400	399	18	user	5	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-05-14 23:05:47.889874	2025-06-08 23:05:47.889874
401	400	37	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
402	401	23	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-14 23:05:47.889874	2025-06-08 23:05:47.889874
403	402	25	user	3	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
404	403	2	user	2	Tasker làm việc cẩu thả, không đáng tiền.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
405	404	36	user	1	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
406	405	28	user	1	Tasker làm việc cẩu thả, không đáng tiền.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
407	406	43	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-15 23:05:47.889874	2025-06-08 23:05:47.889874
408	407	7	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-02 23:05:47.889874	2025-06-08 23:05:47.889874
409	408	10	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
410	409	40	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
411	410	30	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-06-02 23:05:47.889874	2025-06-08 23:05:47.889874
412	411	27	user	3	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-12 23:05:47.889874	2025-06-08 23:05:47.889874
413	412	17	user	2	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
414	413	22	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
415	414	9	user	2	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-12 23:05:47.889874	2025-06-08 23:05:47.889874
416	415	27	user	1	Dịch vụ tệ, tasker không hợp tác, không recommend.	2025-05-12 23:05:47.889874	2025-06-08 23:05:47.889874
417	416	13	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
418	417	12	user	1	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-15 23:05:47.889874	2025-06-08 23:05:47.889874
419	418	37	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-06-03 23:05:47.889874	2025-06-08 23:05:47.889874
420	419	35	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-26 23:05:47.889874	2025-06-08 23:05:47.889874
421	420	38	user	4	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
422	421	24	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
423	422	47	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
424	423	44	user	2	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-12 23:05:47.889874	2025-06-08 23:05:47.889874
425	424	25	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
426	425	49	user	4	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-21 23:05:47.889874	2025-06-08 23:05:47.889874
427	426	10	user	2	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
428	427	8	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-20 23:05:47.889874	2025-06-08 23:05:47.889874
429	428	25	user	2	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
430	429	50	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
431	430	15	user	1	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-22 23:05:47.889874	2025-06-08 23:05:47.889874
432	431	27	user	4	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
433	432	41	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
434	433	15	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
435	434	12	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
436	435	24	user	3	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
437	436	11	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
438	437	32	user	5	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
439	438	18	user	5	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
440	439	30	user	2	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
441	440	18	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
442	441	29	user	2	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
443	442	21	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
444	443	49	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-31 23:05:47.889874	2025-06-08 23:05:47.889874
445	444	4	user	1	Tasker làm việc cẩu thả, không đáng tiền.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
446	445	44	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
447	446	2	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
448	447	5	user	4	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
449	448	23	user	5	Amazing service, tasker rất chu đáo.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
450	449	8	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
451	450	33	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-14 23:05:47.889874	2025-06-08 23:05:47.889874
452	451	44	user	5	Amazing service, tasker rất chu đáo.	2025-05-11 23:05:47.889874	2025-06-08 23:05:47.889874
453	452	18	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
454	453	42	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
455	454	41	user	3	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-06-03 23:05:47.889874	2025-06-08 23:05:47.889874
456	455	20	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-26 23:05:47.889874	2025-06-08 23:05:47.889874
457	456	32	user	1	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-05-14 23:05:47.889874	2025-06-08 23:05:47.889874
458	457	23	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-22 23:05:47.889874	2025-06-08 23:05:47.889874
459	458	23	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-22 23:05:47.889874	2025-06-08 23:05:47.889874
460	459	44	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
461	460	38	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
462	461	12	user	2	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
463	462	25	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
464	463	34	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
465	464	4	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
466	465	30	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
467	466	29	user	4	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
468	467	34	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-06-03 23:05:47.889874	2025-06-08 23:05:47.889874
469	468	16	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
470	469	31	user	3	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
471	470	29	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
472	471	15	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
473	472	41	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
474	473	31	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
475	474	20	user	2	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
476	475	22	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
477	476	50	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
478	477	38	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
479	478	31	user	3	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-26 23:05:47.889874	2025-06-08 23:05:47.889874
480	479	44	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
481	480	33	user	2	Tasker làm việc cẩu thả, không đáng tiền.	2025-05-24 23:05:47.889874	2025-06-08 23:05:47.889874
482	481	5	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
483	482	35	user	2	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
484	483	10	user	3	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
485	484	12	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
486	485	42	user	1	Tasker thái độ kém, làm việc không hiệu quả.	2025-05-28 23:05:47.889874	2025-06-08 23:05:47.889874
487	486	48	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-27 23:05:47.889874	2025-06-08 23:05:47.889874
488	487	3	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
489	488	43	user	4	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
490	489	38	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
491	490	35	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
492	491	21	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-16 23:05:47.889874	2025-06-08 23:05:47.889874
493	492	26	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
494	493	39	user	3	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-17 23:05:47.889874	2025-06-08 23:05:47.889874
495	494	9	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-23 23:05:47.889874	2025-06-08 23:05:47.889874
496	495	14	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện.	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
497	496	12	user	5	Amazing service, tasker rất chu đáo.	2025-06-03 23:05:47.889874	2025-06-08 23:05:47.889874
498	497	45	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
499	498	38	user	2	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
500	499	41	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-15 23:05:47.889874	2025-06-08 23:05:47.889874
501	500	47	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-10 23:05:47.889874	2025-06-08 23:05:47.889874
502	501	40	user	2	Tasker làm việc chậm, không đúng giờ, rất thất vọng.	2025-05-30 23:05:47.889874	2025-06-08 23:05:47.889874
503	502	14	user	4	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-25 23:05:47.889874	2025-06-08 23:05:47.889874
504	503	47	user	4	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-26 23:05:47.889874	2025-06-08 23:05:47.889874
505	504	9	user	2	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-06-07 23:05:47.889874	2025-06-08 23:05:47.889874
506	505	25	user	1	Tasker thái độ kém, làm việc không hiệu quả.	2025-06-01 23:05:47.889874	2025-06-08 23:05:47.889874
507	506	29	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-06-05 23:05:47.889874	2025-06-08 23:05:47.889874
508	507	32	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-06-02 23:05:47.889874	2025-06-08 23:05:47.889874
509	508	25	user	5	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-29 23:05:47.889874	2025-06-08 23:05:47.889874
510	509	48	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-06-04 23:05:47.889874	2025-06-08 23:05:47.889874
511	510	45	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-22 23:05:47.889874	2025-06-08 23:05:47.889874
512	511	23	user	4	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-06-08 23:05:47.889874	2025-06-08 23:05:47.889874
513	512	4	user	3	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
514	513	49	user	4	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-13 23:05:47.889874	2025-06-08 23:05:47.889874
515	514	9	user	4	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
516	515	49	user	4	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-19 23:05:47.889874	2025-06-08 23:05:47.889874
517	516	28	user	4	Dịch vụ bình thường, không có gì nổi bật.	2025-05-09 23:05:47.889874	2025-06-08 23:05:47.889874
518	517	13	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-18 23:05:47.889874	2025-06-08 23:05:47.889874
519	518	5	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-23 23:05:47.890871	2025-06-08 23:05:47.890871
520	519	42	user	2	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
521	520	12	user	2	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
522	521	1	user	1	Very unprofessional, không đáng giá tiền.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
523	522	23	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-05-16 23:05:47.890871	2025-06-08 23:05:47.890871
524	523	5	user	2	Dịch vụ bình thường, không có gì nổi bật.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
525	524	42	user	5	Công việc hoàn thành đúng yêu cầu, tasker rất chu đáo.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
526	525	14	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-09 23:05:47.890871	2025-06-08 23:05:47.890871
527	526	31	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-15 23:05:47.890871	2025-06-08 23:05:47.890871
528	527	33	user	4	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-06-06 23:05:47.890871	2025-06-08 23:05:47.890871
529	528	15	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-06-04 23:05:47.890871	2025-06-08 23:05:47.890871
530	529	19	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
531	530	6	user	4	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
532	531	30	user	5	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-21 23:05:47.890871	2025-06-08 23:05:47.890871
533	532	34	user	5	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	2025-05-15 23:05:47.890871	2025-06-08 23:05:47.890871
534	533	29	user	2	Very unprofessional, không đáng giá tiền.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
535	534	18	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
536	535	3	user	5	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
537	536	4	user	2	Dịch vụ bình thường, không có gì nổi bật.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
538	537	23	user	4	Dịch vụ bình thường, không có gì nổi bật.	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
539	538	44	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
540	539	1	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-06-06 23:05:47.890871	2025-06-08 23:05:47.890871
541	540	13	user	4	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-23 23:05:47.890871	2025-06-08 23:05:47.890871
542	541	23	user	4	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
543	542	38	user	1	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-06-05 23:05:47.890871	2025-06-08 23:05:47.890871
544	543	10	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-10 23:05:47.890871	2025-06-08 23:05:47.890871
545	544	13	user	1	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
546	545	39	user	5	Amazing service, tasker rất chu đáo.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
547	546	28	user	4	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
548	547	47	user	1	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
549	548	36	user	3	Dịch vụ bình thường, không có gì nổi bật.	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
550	549	44	user	3	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
551	550	9	user	4	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
552	551	21	user	1	Không hài lòng, công việc không đúng như kỳ vọng.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
553	552	47	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-06-03 23:05:47.890871	2025-06-08 23:05:47.890871
554	553	36	user	2	Tasker thái độ kém, làm việc không hiệu quả.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
555	554	39	user	4	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
556	555	46	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
557	556	7	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
558	557	46	user	2	Dịch vụ bình thường, không có gì nổi bật.	2025-05-31 23:05:47.890871	2025-06-08 23:05:47.890871
559	558	29	user	5	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	2025-05-09 23:05:47.890871	2025-06-08 23:05:47.890871
560	559	40	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
561	560	48	user	3	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
562	561	11	user	4	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-30 23:05:47.890871	2025-06-08 23:05:47.890871
563	562	47	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-20 23:05:47.890871	2025-06-08 23:05:47.890871
564	563	15	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-18 23:05:47.890871	2025-06-08 23:05:47.890871
565	564	28	user	3	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-20 23:05:47.890871	2025-06-08 23:05:47.890871
566	565	49	user	4	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	2025-05-18 23:05:47.890871	2025-06-08 23:05:47.890871
567	566	45	user	5	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	2025-05-26 23:05:47.890871	2025-06-08 23:05:47.890871
568	567	1	user	1	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-16 23:05:47.890871	2025-06-08 23:05:47.890871
569	568	39	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-15 23:05:47.890871	2025-06-08 23:05:47.890871
570	569	2	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-06-02 23:05:47.890871	2025-06-08 23:05:47.890871
571	570	33	user	3	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2025-05-10 23:05:47.890871	2025-06-08 23:05:47.890871
572	571	27	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-28 23:05:47.890871	2025-06-08 23:05:47.890871
573	572	29	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
574	573	2	user	4	Very professional, highly recommend this service!	2025-06-06 23:05:47.890871	2025-06-08 23:05:47.890871
575	574	18	user	5	Amazing service, tasker rất chu đáo.	2025-06-02 23:05:47.890871	2025-06-08 23:05:47.890871
576	575	36	user	4	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-15 23:05:47.890871	2025-06-08 23:05:47.890871
577	576	20	user	3	Tasker làm việc đúng giờ, nhưng không quá nhanh.	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
578	577	11	user	4	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-27 23:05:47.890871	2025-06-08 23:05:47.890871
579	578	43	user	2	Công việc hoàn thành, nhưng không ấn tượng lắm.	2025-05-28 23:05:47.890871	2025-06-08 23:05:47.890871
580	579	5	user	3	Công việc hoàn thành, nhưng không quá ấn tượng.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
581	580	11	user	2	Very good, nhưng có vài điểm cần cải thiện.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
582	581	24	user	2	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-05-16 23:05:47.890871	2025-06-08 23:05:47.890871
583	582	8	user	3	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-31 23:05:47.890871	2025-06-08 23:05:47.890871
584	583	26	user	1	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
585	584	36	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-05-23 23:05:47.890871	2025-06-08 23:05:47.890871
586	585	11	user	4	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
587	586	48	user	5	Dịch vụ tốt, tasker rất chuyên nghiệp và tận tâm.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
588	587	23	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
589	588	46	user	3	Tasker làm việc đúng yêu cầu, nhưng không quá nhiệt tình.	2025-06-04 23:05:47.890871	2025-06-08 23:05:47.890871
590	589	40	user	3	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
591	590	29	user	1	Tasker làm việc cẩu thả, không đáng tiền.	2025-05-10 23:05:47.890871	2025-06-08 23:05:47.890871
592	591	12	user	4	Very professional, highly recommend this service!	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
593	592	9	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-30 23:05:47.890871	2025-06-08 23:05:47.890871
594	593	10	user	2	Tasker làm ẩu, không đáng để book lại.Dịch vụ không tốt, tasker không chuyên nghiệp.	2025-05-19 23:05:47.890871	2025-06-08 23:05:47.890871
595	594	40	user	1	Dịch vụ không tốt, tasker không chuyên nghiệp, không recommend.	2025-05-19 23:05:47.890871	2025-06-08 23:05:47.890871
596	595	24	user	4	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
597	596	19	user	2	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
598	597	50	user	3	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
599	598	16	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-06-04 23:05:47.890871	2025-06-08 23:05:47.890871
600	599	17	user	1	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
601	600	8	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
602	601	49	user	4	Tasker làm việc nhanh chóng, sạch sẽ, rất ấn tượng.	2025-05-19 23:05:47.890871	2025-06-08 23:05:47.890871
603	602	5	user	2	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	2025-05-27 23:05:47.890871	2025-06-08 23:05:47.890871
604	603	50	user	2	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-06-06 23:05:47.890871	2025-06-08 23:05:47.890871
605	604	7	user	5	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	2025-05-16 23:05:47.890871	2025-06-08 23:05:47.890871
606	605	10	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
607	606	25	user	2	Tasker làm việc chậm, thái độ không tốt.	2025-06-05 23:05:47.890871	2025-06-08 23:05:47.890871
608	607	10	user	4	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-21 23:05:47.890871	2025-06-08 23:05:47.890871
609	608	18	user	5	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
610	609	15	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
611	610	11	user	2	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-10 23:05:47.890871	2025-06-08 23:05:47.890871
612	611	46	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-06-06 23:05:47.890871	2025-06-08 23:05:47.890871
613	612	42	user	2	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-05-10 23:05:47.890871	2025-06-08 23:05:47.890871
614	613	6	user	5	Tasker rất thân thiện, làm việc hiệu quả, sẽ book lại!	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
615	614	1	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-23 23:05:47.890871	2025-06-08 23:05:47.890871
616	615	7	user	1	Tasker làm việc chậm, thái độ không tốt.	2025-06-03 23:05:47.890871	2025-06-08 23:05:47.890871
617	616	32	user	2	Công việc không đạt yêu cầu, tasker cần cải thiện nhiều.	2025-06-01 23:05:47.890871	2025-06-08 23:05:47.890871
618	617	18	user	5	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
619	618	50	user	3	Very good, nhưng có vài điểm cần cải thiện.	2025-06-04 23:05:47.890871	2025-06-08 23:05:47.890871
620	619	9	user	2	Không hài lòng, công việc không đúng như kỳ vọng.	2025-06-05 23:05:47.890871	2025-06-08 23:05:47.890871
621	620	5	user	3	Tasker làm việc đúng giờ, nhưng cần chú ý hơn.	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
622	621	33	user	2	Very disappointed, dịch vụ không đạt yêu cầu.	2025-05-18 23:05:47.890871	2025-06-08 23:05:47.890871
623	622	13	user	4	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2025-05-25 23:05:47.890871	2025-06-08 23:05:47.890871
624	623	47	user	2	Very unprofessional, không đáng giá tiền.	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
625	624	25	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-05-18 23:05:47.890871	2025-06-08 23:05:47.890871
626	625	18	user	1	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2025-05-17 23:05:47.890871	2025-06-08 23:05:47.890871
627	626	22	user	5	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-21 23:05:47.890871	2025-06-08 23:05:47.890871
628	627	25	user	4	Công việc hoàn thành, nhưng không có gì đặc biệt.	2025-05-20 23:05:47.890871	2025-06-08 23:05:47.890871
629	628	14	user	2	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2025-05-13 23:05:47.890871	2025-06-08 23:05:47.890871
630	629	17	user	4	Rất hài lòng với dịch vụ, tasker làm việc rất tốt.	2025-05-16 23:05:47.890871	2025-06-08 23:05:47.890871
631	630	14	user	4	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
632	631	19	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
633	632	1	user	4	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	2025-05-13 23:05:47.890871	2025-06-08 23:05:47.890871
634	633	45	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-23 23:05:47.890871	2025-06-08 23:05:47.890871
635	634	36	user	4	Amazing service, tasker rất chu đáo.	2025-05-14 23:05:47.890871	2025-06-08 23:05:47.890871
636	635	37	user	2	Dịch vụ tạm ổn, nhưng giá hơi cao so với chất lượng.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
637	636	26	user	3	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-28 23:05:47.890871	2025-06-08 23:05:47.890871
638	637	23	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-21 23:05:47.890871	2025-06-08 23:05:47.890871
639	638	40	user	4	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
640	639	6	user	4	Very professional, highly recommend this service!	2025-05-12 23:05:47.890871	2025-06-08 23:05:47.890871
641	640	8	user	3	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-06-08 23:05:47.890871	2025-06-08 23:05:47.890871
642	641	9	user	2	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
643	642	5	user	2	Tasker thái độ kém, làm việc không hiệu quả, không recommend.	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
644	643	3	user	2	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
645	644	2	user	5	Tasker làm việc rất nhanh, thái độ tốt, 5 sao!	2025-05-11 23:05:47.890871	2025-06-08 23:05:47.890871
646	645	6	user	3	Dịch vụ bình thường, không có gì nổi bật.	2025-05-18 23:05:47.890871	2025-06-08 23:05:47.890871
647	646	50	user	2	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2025-05-22 23:05:47.890871	2025-06-08 23:05:47.890871
648	647	19	user	2	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
649	648	35	user	2	Very unprofessional, không đáng giá tiền.	2025-05-30 23:05:47.890871	2025-06-08 23:05:47.890871
650	649	14	user	2	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2025-05-24 23:05:47.890871	2025-06-08 23:05:47.890871
651	650	46	user	2	Rất thất vọng với dịch vụ, tasker không hợp tác.	2025-06-07 23:05:47.890871	2025-06-08 23:05:47.890871
652	140	23	user	5	Không sạch sẽ	2025-06-17 09:47:45.464288	2025-06-17 09:47:45.464288
\.


--
-- TOC entry 5375 (class 0 OID 45452)
-- Dependencies: 257
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id, id) FROM stdin;
1	1	1
1	2	2
1	3	3
1	6	4
1	8	5
1	9	6
1	10	7
1	11	8
1	13	9
1	14	10
1	15	11
1	24	12
2	3	13
2	4	14
2	5	15
2	7	16
2	8	17
2	12	19
2	13	20
2	14	21
2	15	22
2	24	23
3	16	24
3	17	25
3	18	26
3	19	27
3	20	28
3	21	29
3	22	30
3	23	31
3	24	32
3	25	33
3	26	34
2	27	35
1	28	36
1	31	37
2	29	38
2	30	39
2	31	40
1	32	41
2	32	42
2	34	44
2	35	45
2	36	46
1	36	47
2	37	48
1	38	49
1	39	50
1	40	51
1	41	52
1	42	53
1	43	54
1	45	55
2	45	56
2	44	57
2	1	58
2	53	69
1	54	70
1	55	71
1	56	72
1	57	73
1	58	74
1	59	75
1	60	76
1	61	77
\.


--
-- TOC entry 5372 (class 0 OID 45428)
-- Dependencies: 254
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, role_name, description, created_at, updated_at) FROM stdin;
1	user	client	2025-04-19 09:08:44.202014	2025-04-19 09:08:44.202014
2	tasker	tasker	2025-04-19 09:08:57.004056	2025-04-19 09:08:57.004056
3	admin	admin	2025-04-19 09:51:29.013481	2025-04-19 09:51:29.013481
\.


--
-- TOC entry 5403 (class 0 OID 46229)
-- Dependencies: 285
-- Data for Name: sentiment_analysis_detailed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sentiment_analysis_detailed (id, comment, rating, bart_sentiment, bart_confidence, keyword_sentiment, keyword_confidence, sentiment_label, sentiment_confidence) FROM stdin;
1	Tasker rất đúng giờ và thân thiện, làm việc chuyên nghiệp!	5	-1	0.630553662776947	1	0.8	1	0.8
2	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	5	-1	0.793427586555481	1	0.8	-1	0.793427586555481
3	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	4	-1	0.6296150088310242	1	0.8	1	0.8
4	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	5	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
5	Không hài lòng, công việc không đúng như kỳ vọng.	1	-1	0.8937777876853943	-1	0.8	-1	0.8937777876853943
6	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2	-1	0.726780891418457	1	0.6818181818181819	-1	0.726780891418457
7	Tasker làm việc chậm, thái độ không tốt.	1	-1	0.750137209892273	-1	0.8	-1	0.750137209892273
8	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	5	-1	0.6296150088310242	1	0.8	1	0.8
9	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	4	-1	0.6064702868461609	1	0.7	1	0.7
10	Very professional, highly recommend this service!	4	1	0.9942959547042847	1	0.8	1	0.9942959547042847
11	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	4	-1	0.7965139746665955	0	0.3	-1	0.7965139746665955
12	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	2	-1	0.5085372924804688	1	0.6818181818181819	1	0.6818181818181819
13	Tasker làm việc chậm, thái độ không tốt.	2	-1	0.750137209892273	-1	0.8	-1	0.750137209892273
14	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2	-1	0.7074163556098938	1	0.8	-1	0.7074163556098938
15	Amazing service, tasker rất chu đáo.	4	1	0.9868813157081604	1	0.8	1	0.9868813157081604
16	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	4	-1	0.9078336358070374	1	0.8	-1	0.9078336358070374
17	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	4	-1	0.612180233001709	1	0.8	1	0.8
18	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	1	-1	0.8643500208854675	-1	0.8	-1	0.8643500208854675
19	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	5	-1	0.9078336358070374	1	0.8	-1	0.9078336358070374
20	Very good, nhưng có vài điểm cần cải thiện.	2	1	0.6903785467147827	1	0.7222222222222222	1	0.7222222222222222
21	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	5	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
22	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	4	-1	0.7965139746665955	0	0.3	-1	0.7965139746665955
23	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	3	-1	0.7965139746665955	0	0.3	-1	0.7965139746665955
24	Không hài lòng, công việc không đúng như kỳ vọng.	1	-1	0.8937777876853943	-1	0.8	-1	0.8937777876853943
25	Dịch vụ bình thường, giá hơi cao so với chất lượng.	3	-1	0.5995963215827942	0	0.3	-1	0.5995963215827942
26	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2	-1	0.67872554063797	-1	0.8	-1	0.8
27	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	5	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
28	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	4	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
29	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	3	-1	0.7074163556098938	1	0.8	-1	0.7074163556098938
30	Very disappointed, dịch vụ không đạt yêu cầu.	1	-1	0.9970280528068542	-1	0.8	-1	0.9970280528068542
31	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	3	-1	0.7074163556098938	1	0.8	-1	0.7074163556098938
32	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	4	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
33	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	4	-1	0.7691958546638489	1	0.8	-1	0.7691958546638489
34	Dịch vụ tệ, tasker không hợp tác, không recommend.	1	1	0.8100624084472656	-1	0.8	1	0.8100624084472656
35	Tasker ok, nhưng giao tiếp chưa thực sự tốt.	2	-1	0.7691958546638489	1	0.8	-1	0.7691958546638489
36	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	5	1	0.5272984504699707	1	0.8	1	0.8
37	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	1	-1	0.726780891418457	1	0.6818181818181819	-1	0.726780891418457
38	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	4	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
39	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
40	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	5	-1	0.612180233001709	1	0.8	1	0.8
41	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	4	-1	0.8934024572372437	0	0.3	-1	0.8934024572372437
42	Tasker làm đúng yêu cầu, nhưng không quá nổi bật.	4	-1	0.8934024572372437	0	0.3	-1	0.8934024572372437
43	Amazing service, tasker rất chu đáo.	5	1	0.9868813157081604	1	0.8	1	0.9868813157081604
44	Tasker không đúng giờ, làm việc thiếu cẩn thận.	2	-1	0.67872554063797	-1	0.8	-1	0.8
45	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	3	-1	0.7074163556098938	1	0.8	-1	0.7074163556098938
46	Công việc hoàn thành đúng yêu cầu, nhưng không có gì đặc biệt.	3	-1	0.8822627067565918	0	0.3	-1	0.8822627067565918
47	Không hài lòng, công việc không đúng như kỳ vọng.	1	-1	0.8937777876853943	-1	0.8	-1	0.8937777876853943
48	Very disappointed, dịch vụ không đạt yêu cầu.	2	-1	0.9970280528068542	-1	0.8	-1	0.9970280528068542
49	Làm việc nhanh chóng, sạch sẽ, rất đáng tiền.	4	-1	0.6296150088310242	1	0.8	1	0.8
50	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	4	-1	0.9078336358070374	1	0.8	-1	0.9078336358070374
51	Dịch vụ tuyệt vời, tasker nhiệt tình, rất hài lòng.	4	-1	0.9078336358070374	1	0.8	-1	0.9078336358070374
52	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	3	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
53	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2	-1	0.726780891418457	1	0.6818181818181819	-1	0.726780891418457
54	Tasker làm ẩu, không đáng để book lại.	1	-1	0.49471330642700195	-1	0.8	-1	0.8
55	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	1	-1	0.6500344276428223	-1	0.8	-1	0.8
56	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2	-1	0.8643500208854675	-1	0.8	-1	0.8643500208854675
57	Dịch vụ tạm được, tasker cần nhanh nhẹn hơn.	2	-1	0.7074163556098938	1	0.8	-1	0.7074163556098938
58	Công việc hoàn thành, nhưng không ấn tượng lắm.	3	-1	0.6925963759422302	-1	0.7222222222222222	-1	0.7222222222222222
59	Dịch vụ tệ, tasker không hợp tác, không recommend.	2	1	0.8100624084472656	-1	0.8	1	0.8100624084472656
60	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	4	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
61	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	2	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
62	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	3	-1	0.5085372924804688	1	0.6818181818181819	1	0.6818181818181819
63	Tasker làm việc cẩn thận, thái độ tốt, 5 sao!	5	-1	0.6064702868461609	1	0.7	1	0.7
64	Công việc hoàn thành tốt, đúng giờ, sẽ book lại!	5	1	0.5272984504699707	1	0.8	1	0.8
65	Công việc hoàn thành, nhưng không ấn tượng lắm.	2	-1	0.6925963759422302	-1	0.7222222222222222	-1	0.7222222222222222
66	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	1	-1	0.6500344276428223	-1	0.8	-1	0.8
67	Không hài lòng, công việc không đúng như kỳ vọng.	2	-1	0.8937777876853943	-1	0.8	-1	0.8937777876853943
68	Very disappointed, dịch vụ không đạt yêu cầu.	2	-1	0.9970280528068542	-1	0.8	-1	0.9970280528068542
69	Dịch vụ bình thường, giá hơi cao so với chất lượng.	2	-1	0.5995963215827942	0	0.3	-1	0.5995963215827942
70	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	4	-1	0.612180233001709	1	0.8	1	0.8
71	Amazing service, tasker rất chu đáo.	5	1	0.9868813157081604	1	0.8	1	0.9868813157081604
72	Công việc hoàn thành, nhưng không ấn tượng lắm.	3	-1	0.6925963759422302	-1	0.7222222222222222	-1	0.7222222222222222
73	Dịch vụ tệ, tasker không hợp tác, không recommend.	2	1	0.8100624084472656	-1	0.8	1	0.8100624084472656
74	Very disappointed, dịch vụ không đạt yêu cầu.	1	-1	0.9970280528068542	-1	0.8	-1	0.9970280528068542
75	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	5	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
76	Very good, nhưng có vài điểm cần cải thiện.	2	1	0.6903785467147827	1	0.7222222222222222	1	0.7222222222222222
77	Tasker làm việc chậm, thái độ không tốt.	1	-1	0.750137209892273	-1	0.8	-1	0.750137209892273
78	Very unprofessional, không đáng giá tiền.	2	-1	0.9947980642318726	-1	0.8	-1	0.9947980642318726
79	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	5	-1	0.793427586555481	1	0.8	-1	0.793427586555481
80	Dịch vụ tệ, tasker không hợp tác, không recommend.	2	1	0.8100624084472656	-1	0.8	1	0.8100624084472656
81	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	1	-1	0.8643500208854675	-1	0.8	-1	0.8643500208854675
82	Dịch vụ ổn, nhưng tasker cần cải thiện tốc độ.	4	-1	0.7413812279701233	1	0.7	-1	0.7413812279701233
83	Tasker cực kỳ thân thiện, hỗ trợ tận tình.	4	-1	0.5723260641098022	1	0.7222222222222222	1	0.7222222222222222
84	Very professional, highly recommend this service!	4	1	0.9942959547042847	1	0.8	1	0.9942959547042847
85	Rất hài lòng với dịch vụ, tasker thân thiện và chuyên nghiệp.	5	-1	0.612180233001709	1	0.8	1	0.8
86	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	1	-1	0.6500344276428223	-1	0.8	-1	0.8
87	Very professional, highly recommend this service!	5	1	0.9942959547042847	1	0.8	1	0.9942959547042847
88	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	2	-1	0.7965139746665955	0	0.3	-1	0.7965139746665955
89	Tasker làm việc tốt, nhưng đến hơi muộn một chút.	3	-1	0.7965139746665955	0	0.3	-1	0.7965139746665955
90	Công việc hoàn thành, nhưng không ấn tượng lắm.	3	-1	0.6925963759422302	-1	0.7222222222222222	-1	0.7222222222222222
91	Công việc hoàn thành, nhưng không ấn tượng lắm.	3	-1	0.6925963759422302	-1	0.7222222222222222	-1	0.7222222222222222
92	Công việc chưa hoàn thành tốt, tasker cần cải thiện nhiều.	2	-1	0.726780891418457	1	0.6818181818181819	-1	0.726780891418457
93	Very professional, highly recommend this service!	4	1	0.9942959547042847	1	0.8	1	0.9942959547042847
94	Tasker làm ẩu, không đáng để book lại.	1	-1	0.49471330642700195	-1	0.8	-1	0.8
95	Tasker làm việc ổn, nhưng cần chú ý chi tiết hơn.	3	-1	0.5085372924804688	1	0.6818181818181819	1	0.6818181818181819
96	Chất lượng dịch vụ tốt, tasker rất đáng tin cậy.	5	-1	0.793427586555481	1	0.8	-1	0.793427586555481
97	Dịch vụ kém, tasker không chuyên nghiệp, rất thất vọng.	2	-1	0.8643500208854675	-1	0.8	-1	0.8643500208854675
98	Very disappointed, dịch vụ không đạt yêu cầu.	1	-1	0.9970280528068542	-1	0.8	-1	0.9970280528068542
99	Tasker làm việc chậm, thái độ không tốt.	1	-1	0.750137209892273	-1	0.8	-1	0.750137209892273
100	Tasker đến muộn, làm việc cẩu thả, không hài lòng.	1	-1	0.6500344276428223	-1	0.8	-1	0.8
\.


--
-- TOC entry 5346 (class 0 OID 45253)
-- Dependencies: 228
-- Data for Name: service_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_categories (id, name, is_active, is_deleted) FROM stdin;
2	Home Services	t	f
3	Beauty & Art	f	f
4	Care & Gardening	f	f
1	Repair & Maintenance	t	f
\.


--
-- TOC entry 5392 (class 0 OID 46001)
-- Dependencies: 274
-- Data for Name: service_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_packages (id, service_id, name, description, base_price, is_deleted) FROM stdin;
3	20	3 hours	3 rooms - 85m2	180000	f
4	20	4 hours	4 rooms - 105m2	220000	f
5	3	Portable	Portable air conditioner	140000	f
6	3	Split/Multi-Split	Split/Multi air conditioner	250000	f
7	3	Ceiling	Ceiling-mounted air conditioner	280000	f
9	21	2.5 hours	Extended cooking service	180000	f
11	21	3.5 hours	Extended cooking service	250000	f
8	21	2 hours	Basic cooking service\t	145000	f
10	21	3 hours	Basic cooking service\t	220000	f
12	29	Package name	Test	100000	f
2	20	2 hours	2 rooms - 55m2	145000	f
\.


--
-- TOC entry 5348 (class 0 OID 45264)
-- Dependencies: 230
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, category_id, name, description, created_at, updated_at, is_active, icon, is_deleted) FROM stdin;
23	2	Tailor	\N	2025-05-05 22:16:16.367974	2025-05-05 22:16:16.367974	f	tailor_ic.png	f
14	1	TV Repair		2025-05-05 22:10:04.449414	2025-05-05 22:10:04.449414	f	tv_ic.png	f
24	3	Barber		2025-05-05 22:16:30.869132	2025-05-05 22:16:30.869132	f	barber_ic.png	f
27	4	Gardener		2025-05-05 22:17:14.653641	2025-05-05 22:17:14.653641	f	gardener_ic.png	f
26	4	Pet Care		2025-05-05 22:16:54.219496	2025-05-05 22:16:54.219496	f	pet_care_ic.png	f
4	1	Frid Repair		2025-04-15 10:13:57.832	2025-04-15 10:13:57.832	f	fridge_ic.png	f
29	2	Laundry	Updated	2025-06-14 22:43:55.023575	2025-06-14 22:45:39.294685	\N	\N	t
3	1	AC Repair		2025-04-15 10:13:26.405	2025-06-15 09:55:29.444811	f	repair_ac_ic.png	f
16	1	Electrician	\N	2025-05-05 22:14:56.059788	2025-05-05 22:14:56.059788	f	electrician_ic.png	f
18	1	Plumber	\N	2025-05-05 22:15:10.116661	2025-05-05 22:15:10.116661	f	plumber_ic.png	f
20	2	Cleaning	\N	2025-05-05 22:15:51.732858	2025-05-05 22:15:51.732858	t	cleaning_ic.png	f
21	2	Cooking	\N	2025-05-05 22:15:59.421837	2025-05-05 22:15:59.421837	t	cooking_ic.png	f
25	3	Painter	\N	2025-05-05 22:16:41.286894	2025-05-05 22:16:41.286894	f	painter_ic.png	f
1	1	Car Repair		2025-04-15 10:12:07.581	2025-04-15 10:12:07.581	f	car_ic.png	f
19	1	Van	\N	2025-05-05 22:15:32.773453	2025-05-05 22:15:32.773453	f	van_ic.png	f
22	2	Labor	\N	2025-05-05 22:16:08.006732	2025-05-05 22:16:08.006732	f	labor_ic.png	f
\.


--
-- TOC entry 5340 (class 0 OID 45217)
-- Dependencies: 222
-- Data for Name: tasker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker (id, email, phone_number, password_hash, first_last_name, profile_image, address, latitude, longitude, average_rating, total_earnings, availability_status, created_at, updated_at, last_login, is_verified, is_active) FROM stdin;
1	tasker@gmail.com	1891555024	$2a$10$L2SU/jWSmk8MhDtkfFjwsO1mBG0BEBO7YbiAgsu8iNUK1OExLNiVe	Tasker	\N	\N	10.79490000	106.72190000	0.00	0.00	available	2025-04-10 22:59:59.422	2025-04-14 15:51:37.02	\N	t	f
2	a@gmail.com	12345679	ascwaw	Nguyễn Văn A	\N	\N	10.77350000	106.70600000	0.00	0.00	available	2025-04-16 21:59:11.727574	2025-04-16 21:59:11.727574	\N	f	t
3	B@gmail.com	0123657892	ascwaw	Nguyễn Văn B	\N	\N	10.78000000	106.71000000	0.00	0.00	available	2025-04-16 21:59:11.727574	2025-04-16 21:59:11.727574	\N	f	t
4	c@gmail.com	032633553	ascwaw	Nguyễn Văn C	\N	\N	10.80000000	106.72000000	0.00	0.00	busy	2025-04-16 21:59:11.727574	2025-04-16 21:59:11.727574	\N	f	t
10	6251071063	7639221905	$2a$10$4PM29nueZ.Hj2NmNtvqb0OgVw2Aop0JLcor0oql9mJJDiJ8dLo9Zu	Dang Minh	\N	\N	0.00000000	0.00000000	\N	\N	available	2025-04-19 16:06:23.986	2025-04-19 16:06:23.986	\N	t	t
32	scas@gmail.com	0347895789	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Hồng Đậu	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-05-30 15:06:51.825	\N	t	t
34	xzcs@gmail.com	0347845332	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Thanh Thiên	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-05-30 15:06:51.825	\N	t	t
35	zws@gmail.com	0347325632	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Mạn Quân	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-05-30 15:06:51.825	\N	t	t
30	dangocmin@gmail.com	0347895632	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Mang Dinh	https://res.cloudinary.com/duqxubsnw/image/upload/v1750130617/bcfwm548mhqrlisgfsy4.jpg		\N	\N	\N	\N	available	2025-05-24 21:54:15.169	2025-06-17 10:23:38.283	\N	t	t
31	dscs@gmail.com	0347895632	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Na Na	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-06-24 22:28:41.833	\N	t	t
33	cs@gmail.com	0347812332	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Đại Mạch	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-06-24 22:28:41.865	\N	t	t
38	sacw@gmail.com	0347895756	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Sở Sở	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-05-30 15:06:51.825	\N	t	t
39	cas@gmail.com	0347895421	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	A Quế	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-05-30 15:06:51.825	\N	t	t
37	wds@gmail.com	0347892362	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Tiểu Nguyệt	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-06-24 22:28:41.888	\N	t	t
36	mgai@gmail.com	0347812732	$2a$10$DhfB.9.x/m2Xwno2Dnm9Metfjj7RtfZj34emkGKVet0qqr16ue6.e	Bảo Bình	\N	\N	\N	\N	0.00	0.00	available	2025-05-24 21:54:15.169	2025-06-24 22:28:41.906	\N	t	t
\.


--
-- TOC entry 5358 (class 0 OID 45344)
-- Dependencies: 240
-- Data for Name: tasker_earnings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_earnings (id, tasker_id, booking_id, amount, platform_fee, net_amount, status, created_at, paid_at) FROM stdin;
\.


--
-- TOC entry 5409 (class 0 OID 46262)
-- Dependencies: 291
-- Data for Name: tasker_exposure_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_exposure_stats (id, tasker_id, notification_count, assigned_job_count, registration_date, last_job_date, created_at, updated_at) FROM stdin;
1	35	9	0	\N	\N	2025-06-15 11:07:17.737938	2025-06-17 10:58:24.630261
3	39	9	0	\N	\N	2025-06-15 11:07:18.283414	2025-06-17 10:58:24.914675
2	34	9	0	\N	\N	2025-06-15 11:07:18.275226	2025-06-17 10:58:24.922305
4	38	9	0	\N	\N	2025-06-15 11:07:18.341965	2025-06-17 10:58:24.928371
5	30	2	5	\N	2025-06-17 16:44:07.50627	2025-06-17 10:36:07.455395	2025-06-17 16:44:12.634544
\.


--
-- TOC entry 5400 (class 0 OID 46131)
-- Dependencies: 282
-- Data for Name: tasker_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_notification (id, tasker_id, booking_id, title, message, notification_type, is_read, created_at) FROM stdin;
11	35	651	New Job Available	A new Cleaning job is available at 240 Đường Tôn Thất Tùng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-15 11:07:18.059475
12	34	651	New Job Available	A new Cleaning job is available at 240 Đường Tôn Thất Tùng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-15 11:07:18.277453
13	39	651	New Job Available	A new Cleaning job is available at 240 Đường Tôn Thất Tùng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-15 11:07:18.331393
14	38	651	New Job Available	A new Cleaning job is available at 240 Đường Tôn Thất Tùng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-15 11:07:18.343551
15	39	652	New Job Available	A new Cleaning job is available at Hoa Tươi Thiên An, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 09:40:06.997213
16	34	652	New Job Available	A new Cleaning job is available at Hoa Tươi Thiên An, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 09:40:07.063267
17	35	652	New Job Available	A new Cleaning job is available at Hoa Tươi Thiên An, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 09:40:07.076796
18	38	652	New Job Available	A new Cleaning job is available at Hoa Tươi Thiên An, Cách Mạng Tháng 8, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 09:40:07.090142
19	35	653	New Job Available	A new Cooking job is available at 124 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 09:45:40.937539
20	34	653	New Job Available	A new Cooking job is available at 124 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 09:45:40.953842
21	38	653	New Job Available	A new Cooking job is available at 124 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 09:45:40.964436
22	39	653	New Job Available	A new Cooking job is available at 124 Trường Chinh, Phú Mỹ, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 09:45:40.973214
23	35	654	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:16:54.289525
24	39	654	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:16:54.302641
25	34	654	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:16:54.311505
26	38	654	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:16:54.319553
27	38	655	New Job Available	A new Cleaning job is available at Hoa Viên Tiệc Cưới Thạch Linh Trúc, Trần Hưng Đạo, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:18:48.142495
28	34	655	New Job Available	A new Cleaning job is available at Hoa Viên Tiệc Cưới Thạch Linh Trúc, Trần Hưng Đạo, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:18:48.153532
29	39	655	New Job Available	A new Cleaning job is available at Hoa Viên Tiệc Cưới Thạch Linh Trúc, Trần Hưng Đạo, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:18:48.178948
30	35	655	New Job Available	A new Cleaning job is available at Hoa Viên Tiệc Cưới Thạch Linh Trúc, Trần Hưng Đạo, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:18:48.193081
31	35	656	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:19:25.538577
32	39	656	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:19:25.544435
33	34	656	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:19:25.561358
34	38	656	New Job Available	A new Cleaning job is available at Xe đạp, xe đạp điện Anh Khôi, xe đạp điện Anh Khôi, 188 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:19:25.568805
35	35	657	New Job Available	A new Cleaning job is available at Cafe Tina, Tân Phước, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 10:32:23.067567
36	39	657	New Job Available	A new Cleaning job is available at Cafe Tina, Tân Phước, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 10:32:23.078877
37	34	657	New Job Available	A new Cleaning job is available at Cafe Tina, Tân Phước, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 10:32:23.085584
38	38	657	New Job Available	A new Cleaning job is available at Cafe Tina, Tân Phước, Phú Mỹ, Bà Rịa-Vũng Tàu	NEW_TASK	f	2025-06-17 10:32:23.093834
39	30	658	New Job Available	A new Cleaning job is available at Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:36:07.459153
2	30	46	New Job Available	A new Cleaning job is available at Mốc Xì Koi farm & Coffee, Đường Lê Lợi, khu ĐTM, Phú Mỹ, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-05-30 00:06:11.292794
3	35	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:35.471619
4	30	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:35.503371
5	39	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.402467
6	34	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.415
7	37	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.422436
8	36	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.438859
9	38	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.453153
10	33	48	New Job Available	A new Cooking job is available at 863 Nguyễn Xiển	NEW_TASK	f	2025-06-09 14:45:36.46328
40	39	658	New Job Available	A new Cleaning job is available at Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:36:08.635516
41	34	658	New Job Available	A new Cleaning job is available at Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:36:08.641878
42	35	658	New Job Available	A new Cleaning job is available at Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:36:08.650445
43	38	658	New Job Available	A new Cleaning job is available at Vật Liệu Xây Dựng Thành Luân, Mỹ Xuân - Ngãi Giao, Mỹ Xuân, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:36:08.657966
44	35	659	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:58:24.610535
45	30	659	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:58:24.63327
46	39	659	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:58:24.910149
47	34	659	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:58:24.916692
48	38	659	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-17 10:58:24.924846
49	30	660	New Job Available	A new Cleaning job is available at Nhà Nghỉ 46, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-23 22:39:24.321021
50	30	661	New Job Available	A new Cleaning job is available at 80 Nguyễn Lương Bằng, Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-23 22:40:58.841861
51	30	662	New Job Available	A new Cooking job is available at 182 Đ. Trường Chinh, TT. Phú Mỹ, Tân Thành, Bà Rịa - Vũng Tàu	NEW_TASK	f	2025-06-23 22:49:56.844502
\.


--
-- TOC entry 5360 (class 0 OID 45352)
-- Dependencies: 242
-- Data for Name: tasker_payouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_payouts (id, tasker_id, amount, payout_method, account_details, status, transaction_id, request_date, process_date, notes) FROM stdin;
\.


--
-- TOC entry 5405 (class 0 OID 46243)
-- Dependencies: 287
-- Data for Name: tasker_reputation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_reputation (tasker_id, reputation_score, id) FROM stdin;
30	1.950343936091939	1
31	1.911099645161293	2
32	1.9243249202331958	3
33	1.819891443662547	4
34	1.8985965832468568	5
35	1.9956865965469048	6
36	1.86700643089755	7
37	1.8793387187895365	8
38	1.8450404387295787	9
39	1.9078755526439601	10
\.


--
-- TOC entry 5380 (class 0 OID 45812)
-- Dependencies: 262
-- Data for Name: tasker_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_roles (tasker_id, role_id, id) FROM stdin;
1	2	1
10	2	2
30	2	9
\.


--
-- TOC entry 5350 (class 0 OID 45276)
-- Dependencies: 232
-- Data for Name: tasker_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_services (id, tasker_id, service_id, is_verified, tasker_name, service_name) FROM stdin;
33	30	20	t	Mang Dinh	Cleaning
34	30	21	t	Mang Dinh	Cooking
35	30	26	t	Mang Dinh	Pet Care
36	33	20	t	Mang Dinh	Cleaning
37	33	21	t	Mang Dinh	Cooking
38	33	26	t	Mang Dinh	Pet Care
39	34	20	t	Mang Dinh	Cleaning
40	34	21	t	Mang Dinh	Cooking
41	34	26	t	Mang Dinh	Pet Care
42	35	20	t	Mang Dinh	Cleaning
43	35	21	t	Mang Dinh	Cooking
44	35	26	t	Mang Dinh	Pet Care
45	36	20	t	Mang Dinh	Cleaning
46	36	21	t	Mang Dinh	Cooking
47	36	26	t	Mang Dinh	Pet Care
48	37	20	t	Mang Dinh	Cleaning
49	37	21	t	Mang Dinh	Cooking
50	37	26	t	Mang Dinh	Pet Care
51	38	20	t	Mang Dinh	Cleaning
52	38	21	t	Mang Dinh	Cooking
53	38	26	t	Mang Dinh	Pet Care
56	39	21	t	Mang Dinh	Cooking
57	39	26	t	Mang Dinh	Pet Care
55	39	20	t	Mang Dinh	Cleaning
\.


--
-- TOC entry 5389 (class 0 OID 45936)
-- Dependencies: 271
-- Data for Name: tasker_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_transaction (id, tasker_id, amount, type, status, description, created_at) FROM stdin;
1	30	140000.00	ADJUSTMENT	SUCCESS	test	2025-05-28 09:37:07.200818
2	30	70000.00	ADJUSTMENT	SUCCESS	Check wrong day so can not work.	2025-05-28 11:16:54.488094
3	30	70000.00	ADJUSTMENT	SUCCESS	Check wrong day so can not work.	2025-05-28 11:18:55.270106
5	30	112000.00	INCOME	SUCCESS	Income from job	2025-05-28 22:47:18.863942
6	30	112000.00	INCOME	SUCCESS	Income from job	2025-05-28 22:50:45.949906
7	30	112000.00	INCOME	SUCCESS	Income from job	2025-05-28 22:54:50.030705
\.


--
-- TOC entry 5370 (class 0 OID 45409)
-- Dependencies: 252
-- Data for Name: tasker_unavailable_dates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_unavailable_dates (id, tasker_id, start_date, end_date, reason) FROM stdin;
\.


--
-- TOC entry 5387 (class 0 OID 45901)
-- Dependencies: 269
-- Data for Name: tasker_wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasker_wallet (id, tasker_id, balance, updated_at) FROM stdin;
1	30	224000.00	2025-05-28 22:54:50.024188
\.


--
-- TOC entry 5352 (class 0 OID 45288)
-- Dependencies: 234
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_addresses (id, user_id, address_name, latitude, longitude, is_default, created_at, updated_at, apartment_type, houser_number) FROM stdin;
\.


--
-- TOC entry 5398 (class 0 OID 46120)
-- Dependencies: 280
-- Data for Name: user_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_notifications (id, user_id, booking_id, title, message, notification_type, is_read, created_at) FROM stdin;
1	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 11:20:32.924288
2	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 11:25:51.613714
3	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 15:50:52.269084
4	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 15:53:34.862723
5	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 15:55:41.718866
6	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 16:01:20.320335
7	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 16:03:10.26383
8	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 16:06:05.123535
9	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 16:12:11.750237
10	23	47	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-03 16:20:46.801471
12	23	659	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-17 11:00:35.381223
13	23	659	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-17 11:15:45.527649
14	23	659	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-17 11:23:25.38495
15	23	659	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-17 16:26:43.402953
16	23	659	Job Accepted	Your job has been accepted by Mang Dinh	JOB_ACCEPTED	f	2025-06-17 16:44:07.507752
\.


--
-- TOC entry 5368 (class 0 OID 45397)
-- Dependencies: 250
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_preferences (id, user_id, service_category_id, preference_level, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5376 (class 0 OID 45457)
-- Dependencies: 258
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id, id) FROM stdin;
2	1	1
23	1	14
40	3	15
\.


--
-- TOC entry 5396 (class 0 OID 46059)
-- Dependencies: 278
-- Data for Name: user_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_transaction (id, user_id, amount, description, created_at, transaction_type) FROM stdin;
1020b04f-c15b-4918-aef4-548c9244b072	23	100030.00	Using BPay to pay for card replacement service	2025-05-16 16:25:38.738735	deposit
d81c7e8e-f149-45cf-988c-0b002cc5695b	23	100029.00	Refund for call appointment	2025-05-16 16:26:02.970258	deposit
61ecad9e-53dd-4fe8-80ec-5c995d11647b	23	100016.00	Job cancellation	2025-05-16 16:26:22.350361	payment
2afdc43c-6dc2-422f-86b9-7a667e2487fa	23	100014.00	Deposit to BPay	2025-05-16 16:26:45.922914	deposit
7cd01137-c5de-4d48-9f46-99833260c704	23	300000.00	Deposit: +$300,000.00 added to wallet	2025-05-16 23:15:00.615611	deposit
8bdd7b97-f839-4865-8b8c-2c75e536e58d	23	500000.00	Deposit: +$500,000.00 added to wallet	2025-05-16 23:18:31.13551	deposit
3dc1733d-92b0-4c12-a3b4-76d83207f34c	23	50000.00	Deposit: +$50,000.00 added to wallet	2025-05-16 23:19:47.268216	deposit
d26e5578-9d7f-49a7-af02-4867895f8f38	23	200000.00	Deposit: +200,000 VND added to wallet	2025-05-17 09:23:06.009569	deposit
2c2e0971-844e-4e09-8e19-2b003b481c51	23	10000.00	Deposit: +10,000 VND added to wallet	2025-05-17 09:32:01.792597	deposit
8842b8ec-b07e-454b-b788-79cdb6e04304	23	140000.00	Payment: -140,000 VND deducted from wallet	2025-05-17 09:34:30.532809	payment
2b9e98e1-eb04-4321-adf1-087cf0057994	2	192.00	Payment: -192 VND deducted from wallet	2025-05-17 10:55:46.880929	payment
05946076-8a31-412e-a612-c8f12e7df6b4	23	200000.00	Deposit: +200,000 VND added to wallet	2025-06-16 16:35:43.666412	deposit
4856c160-2d10-4d17-8f98-b6d8f99db6bd	23	145000.00	Payment: -145,000 VND deducted from wallet	2025-06-17 09:45:40.740761	payment
4936f3b3-e843-46c2-8cea-54528dcca503	23	50000.00	Deposit: +50,000 VND added to wallet	2025-06-17 09:48:12.034824	deposit
\.


--
-- TOC entry 5342 (class 0 OID 45234)
-- Dependencies: 224
-- Data for Name: user_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_verifications (id, user_id, tasker_id, verification_code, verification_type, created_at, expires_at, is_used) FROM stdin;
\.


--
-- TOC entry 5385 (class 0 OID 45892)
-- Dependencies: 267
-- Data for Name: user_wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_wallet (id, user_id, balance, updated_at) FROM stdin;
1	2	249616.00	2025-05-17 10:55:46.877877
4	23	205000.00	2025-06-17 09:48:12.034824
\.


--
-- TOC entry 5338 (class 0 OID 45196)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, phone_number, password_hash, first_last_name, profile_image, address, user_type, created_at, updated_at, last_login, is_verified, is_active) FROM stdin;
2	dangocmin	4243849968	$2a$10$Bp7cF0pCzVmfJLBXShB6he9Bmj0K7a9YWPAmIFJ0EiLgAJ0P47Pfy	Ngọc Minh	string	863 Nguyen Xien	customer	2025-04-12 09:29:51.286	2025-04-14 15:37:39.654	\N	\N	t
23	dangg.minh.tech@gmail.com	0978123456	$2a$10$BNQQ8mUjy8AB4lkDfmBJFOArojGNW5tnuKJFWU8rJjdDa7sX7sonW	Đăng Minh	https://res.cloudinary.com/duqxubsnw/image/upload/v1747369107/kvvmssnyn5xcq9exqz0q.jpg		customer	2025-05-03 15:54:00.565	2025-05-29 23:15:28.193	\N	t	t
40	6251071063@st.utc2.edu.vn	0347592129	$2a$10$BNQQ8mUjy8AB4lkDfmBJFOArojGNW5tnuKJFWU8rJjdDa7sX7sonW	Đặng Minh	https://res.cloudinary.com/duqxubsnw/image/upload/v1747369107/kvvmssnyn5xcq9exqz0q.jpg		admin	2025-05-03 15:54:00.565	2025-05-29 23:15:28.193	\N	t	t
\.


--
-- TOC entry 5453 (class 0 OID 0)
-- Dependencies: 235
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_id_seq', 662, true);


--
-- TOC entry 5454 (class 0 OID 0)
-- Dependencies: 247
-- Name: chat_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_messages_id_seq', 97, true);


--
-- TOC entry 5455 (class 0 OID 0)
-- Dependencies: 245
-- Name: chat_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_rooms_id_seq', 7, true);


--
-- TOC entry 5456 (class 0 OID 0)
-- Dependencies: 259
-- Name: chatbot_interactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatbot_interactions_id_seq', 17, true);


--
-- TOC entry 5457 (class 0 OID 0)
-- Dependencies: 225
-- Name: favorite_tasker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorite_tasker_id_seq', 6, true);


--
-- TOC entry 5458 (class 0 OID 0)
-- Dependencies: 283
-- Name: fcm_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fcm_tokens_id_seq', 2, true);


--
-- TOC entry 5459 (class 0 OID 0)
-- Dependencies: 261
-- Name: global_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.global_user_id_seq', 40, true);


--
-- TOC entry 5460 (class 0 OID 0)
-- Dependencies: 275
-- Name: package_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.package_variants_id_seq', 10, true);


--
-- TOC entry 5461 (class 0 OID 0)
-- Dependencies: 276
-- Name: package_variants_package_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.package_variants_package_id_seq', 1, false);


--
-- TOC entry 5462 (class 0 OID 0)
-- Dependencies: 237
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 32, true);


--
-- TOC entry 5463 (class 0 OID 0)
-- Dependencies: 255
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 61, true);


--
-- TOC entry 5464 (class 0 OID 0)
-- Dependencies: 243
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 652, true);


--
-- TOC entry 5465 (class 0 OID 0)
-- Dependencies: 263
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 77, true);


--
-- TOC entry 5466 (class 0 OID 0)
-- Dependencies: 253
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 227
-- Name: service_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_categories_id_seq', 5, true);


--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 272
-- Name: service_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_packages_id_seq', 12, true);


--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 273
-- Name: service_packages_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_packages_service_id_seq', 1, false);


--
-- TOC entry 5470 (class 0 OID 0)
-- Dependencies: 229
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_id_seq', 31, true);


--
-- TOC entry 5471 (class 0 OID 0)
-- Dependencies: 239
-- Name: tasker_earnings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_earnings_id_seq', 1, false);


--
-- TOC entry 5472 (class 0 OID 0)
-- Dependencies: 290
-- Name: tasker_exposure_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_exposure_stats_id_seq', 5, true);


--
-- TOC entry 5473 (class 0 OID 0)
-- Dependencies: 221
-- Name: tasker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_id_seq', 5, true);


--
-- TOC entry 5474 (class 0 OID 0)
-- Dependencies: 281
-- Name: tasker_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_notification_id_seq', 51, true);


--
-- TOC entry 5475 (class 0 OID 0)
-- Dependencies: 241
-- Name: tasker_payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_payouts_id_seq', 1, false);


--
-- TOC entry 5476 (class 0 OID 0)
-- Dependencies: 289
-- Name: tasker_reputation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_reputation_id_seq', 10, true);


--
-- TOC entry 5477 (class 0 OID 0)
-- Dependencies: 265
-- Name: tasker_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_roles_id_seq', 9, true);


--
-- TOC entry 5478 (class 0 OID 0)
-- Dependencies: 231
-- Name: tasker_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_services_id_seq', 57, true);


--
-- TOC entry 5479 (class 0 OID 0)
-- Dependencies: 270
-- Name: tasker_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_transaction_id_seq', 7, true);


--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 251
-- Name: tasker_unavailable_dates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_unavailable_dates_id_seq', 1, false);


--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 268
-- Name: tasker_wallet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasker_wallet_id_seq', 1, true);


--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 233
-- Name: user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_addresses_id_seq', 1, true);


--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 279
-- Name: user_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_notifications_id_seq', 16, true);


--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 249
-- Name: user_preferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_preferences_id_seq', 1, false);


--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 264
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 15, true);


--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 223
-- Name: user_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_verifications_id_seq', 1, false);


--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 266
-- Name: user_wallet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_wallet_id_seq', 4, true);


--
-- TOC entry 5488 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 300, false);


--
-- TOC entry 5077 (class 2606 OID 45310)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5099 (class 2606 OID 45395)
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5095 (class 2606 OID 45382)
-- Name: chat_rooms chat_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 5097 (class 2606 OID 45384)
-- Name: chat_rooms chat_rooms_user_id_tasker_id_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_user_id_tasker_id_booking_id_key UNIQUE (user_id, tasker_id, booking_id);


--
-- TOC entry 5123 (class 2606 OID 45499)
-- Name: chatbot_interactions chatbot_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5060 (class 2606 OID 45249)
-- Name: favorite_tasker favorite_tasker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker
    ADD CONSTRAINT favorite_tasker_pkey PRIMARY KEY (id);


--
-- TOC entry 5062 (class 2606 OID 45251)
-- Name: favorite_tasker favorite_tasker_user_id_tasker_id_service_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker
    ADD CONSTRAINT favorite_tasker_user_id_tasker_id_service_id_key UNIQUE (user_id, tasker_id, service_id);


--
-- TOC entry 5145 (class 2606 OID 46151)
-- Name: fcm_tokens fcm_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5137 (class 2606 OID 46025)
-- Name: package_variants package_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_variants
    ADD CONSTRAINT package_variants_pkey PRIMARY KEY (id);


--
-- TOC entry 5086 (class 2606 OID 45342)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 5113 (class 2606 OID 45449)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5093 (class 2606 OID 45373)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5115 (class 2606 OID 45838)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5117 (class 2606 OID 45840)
-- Name: role_permissions role_permissions_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_unique UNIQUE (role_id, permission_id);


--
-- TOC entry 5109 (class 2606 OID 45437)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5111 (class 2606 OID 45439)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 5064 (class 2606 OID 45261)
-- Name: service_categories service_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_categories
    ADD CONSTRAINT service_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 5135 (class 2606 OID 46009)
-- Name: service_packages service_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_packages
    ADD CONSTRAINT service_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 5067 (class 2606 OID 45274)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- TOC entry 5089 (class 2606 OID 45350)
-- Name: tasker_earnings tasker_earnings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_earnings
    ADD CONSTRAINT tasker_earnings_pkey PRIMARY KEY (id);


--
-- TOC entry 5054 (class 2606 OID 45232)
-- Name: tasker tasker_email_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker
    ADD CONSTRAINT tasker_email_phone_number_key UNIQUE (email, phone_number);


--
-- TOC entry 5149 (class 2606 OID 46269)
-- Name: tasker_exposure_stats tasker_exposure_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_exposure_stats
    ADD CONSTRAINT tasker_exposure_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 5151 (class 2606 OID 46271)
-- Name: tasker_exposure_stats tasker_exposure_stats_tasker_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_exposure_stats
    ADD CONSTRAINT tasker_exposure_stats_tasker_id_key UNIQUE (tasker_id);


--
-- TOC entry 5143 (class 2606 OID 46140)
-- Name: tasker_notification tasker_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_notification
    ADD CONSTRAINT tasker_notification_pkey PRIMARY KEY (id);


--
-- TOC entry 5091 (class 2606 OID 45360)
-- Name: tasker_payouts tasker_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_payouts
    ADD CONSTRAINT tasker_payouts_pkey PRIMARY KEY (id);


--
-- TOC entry 5056 (class 2606 OID 45230)
-- Name: tasker tasker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker
    ADD CONSTRAINT tasker_pkey PRIMARY KEY (id);


--
-- TOC entry 5147 (class 2606 OID 46251)
-- Name: tasker_reputation tasker_reputation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_reputation
    ADD CONSTRAINT tasker_reputation_pkey PRIMARY KEY (id);


--
-- TOC entry 5125 (class 2606 OID 45860)
-- Name: tasker_roles tasker_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_roles
    ADD CONSTRAINT tasker_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5127 (class 2606 OID 45862)
-- Name: tasker_roles tasker_roles_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_roles
    ADD CONSTRAINT tasker_roles_unique UNIQUE (tasker_id, role_id);


--
-- TOC entry 5071 (class 2606 OID 45284)
-- Name: tasker_services tasker_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_services
    ADD CONSTRAINT tasker_services_pkey PRIMARY KEY (id);


--
-- TOC entry 5073 (class 2606 OID 45286)
-- Name: tasker_services tasker_services_tasker_id_service_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_services
    ADD CONSTRAINT tasker_services_tasker_id_service_id_key UNIQUE (tasker_id, service_id);


--
-- TOC entry 5133 (class 2606 OID 45945)
-- Name: tasker_transaction tasker_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_transaction
    ADD CONSTRAINT tasker_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 5107 (class 2606 OID 45414)
-- Name: tasker_unavailable_dates tasker_unavailable_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_unavailable_dates
    ADD CONSTRAINT tasker_unavailable_dates_pkey PRIMARY KEY (id);


--
-- TOC entry 5131 (class 2606 OID 45908)
-- Name: tasker_wallet tasker_wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_wallet
    ADD CONSTRAINT tasker_wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 5075 (class 2606 OID 45298)
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 5141 (class 2606 OID 46129)
-- Name: user_notifications user_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5103 (class 2606 OID 45405)
-- Name: user_preferences user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (id);


--
-- TOC entry 5105 (class 2606 OID 45407)
-- Name: user_preferences user_preferences_user_id_service_category_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_user_id_service_category_id_key UNIQUE (user_id, service_category_id);


--
-- TOC entry 5119 (class 2606 OID 45849)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5121 (class 2606 OID 45851)
-- Name: user_roles user_roles_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_unique UNIQUE (user_id, role_id);


--
-- TOC entry 5139 (class 2606 OID 46068)
-- Name: user_transaction user_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_transaction
    ADD CONSTRAINT user_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 5058 (class 2606 OID 45242)
-- Name: user_verifications user_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_verifications
    ADD CONSTRAINT user_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5129 (class 2606 OID 45899)
-- Name: user_wallet user_wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wallet
    ADD CONSTRAINT user_wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 5049 (class 2606 OID 45209)
-- Name: users users_email_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_phone_number_key UNIQUE (email, phone_number);


--
-- TOC entry 5051 (class 2606 OID 45207)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5078 (class 1259 OID 45520)
-- Name: idx_bookings_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_created_at ON public.bookings USING btree (created_at);


--
-- TOC entry 5079 (class 1259 OID 45514)
-- Name: idx_bookings_service_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_service_id ON public.bookings USING btree (service_id);


--
-- TOC entry 5080 (class 1259 OID 45509)
-- Name: idx_bookings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_status ON public.bookings USING btree (status);


--
-- TOC entry 5081 (class 1259 OID 45513)
-- Name: idx_bookings_tasker_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_tasker_id ON public.bookings USING btree (tasker_id);


--
-- TOC entry 5082 (class 1259 OID 45521)
-- Name: idx_bookings_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_updated_at ON public.bookings USING btree (updated_at);


--
-- TOC entry 5083 (class 1259 OID 45512)
-- Name: idx_bookings_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_user_id ON public.bookings USING btree (user_id);


--
-- TOC entry 5100 (class 1259 OID 45516)
-- Name: idx_chat_messages_room_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_room_id ON public.chat_messages USING btree (room_id);


--
-- TOC entry 5101 (class 1259 OID 45517)
-- Name: idx_chat_messages_sent_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_sent_at ON public.chat_messages USING btree (sent_at);


--
-- TOC entry 5084 (class 1259 OID 45515)
-- Name: idx_payments_booking_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_booking_id ON public.payments USING btree (booking_id);


--
-- TOC entry 5065 (class 1259 OID 45518)
-- Name: idx_services_name_description; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_name_description ON public.services USING gin (to_tsvector('simple'::regconfig, (((name)::text || ' '::text) || COALESCE(description, ''::text))));


--
-- TOC entry 5087 (class 1259 OID 45523)
-- Name: idx_tasker_earnings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasker_earnings_status ON public.tasker_earnings USING btree (tasker_id, status);


--
-- TOC entry 5052 (class 1259 OID 45519)
-- Name: idx_tasker_rating_services; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasker_rating_services ON public.tasker USING btree (average_rating, availability_status);


--
-- TOC entry 5068 (class 1259 OID 45511)
-- Name: idx_tasker_services_service_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasker_services_service_id ON public.tasker_services USING btree (service_id);


--
-- TOC entry 5069 (class 1259 OID 45510)
-- Name: idx_tasker_services_tasker_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasker_services_tasker_id ON public.tasker_services USING btree (tasker_id);


--
-- TOC entry 5161 (class 2606 OID 46031)
-- Name: bookings bookings_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.service_packages(id) ON DELETE CASCADE;


--
-- TOC entry 5162 (class 2606 OID 45579)
-- Name: bookings bookings_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- TOC entry 5163 (class 2606 OID 45574)
-- Name: bookings bookings_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5164 (class 2606 OID 45569)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5175 (class 2606 OID 45654)
-- Name: chat_messages chat_messages_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id);


--
-- TOC entry 5172 (class 2606 OID 45639)
-- Name: chat_rooms chat_rooms_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- TOC entry 5173 (class 2606 OID 45649)
-- Name: chat_rooms chat_rooms_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5174 (class 2606 OID 45644)
-- Name: chat_rooms chat_rooms_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5183 (class 2606 OID 45739)
-- Name: chatbot_interactions chatbot_interactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5154 (class 2606 OID 45544)
-- Name: favorite_tasker favorite_tasker_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker
    ADD CONSTRAINT favorite_tasker_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- TOC entry 5155 (class 2606 OID 45539)
-- Name: favorite_tasker favorite_tasker_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker
    ADD CONSTRAINT favorite_tasker_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5156 (class 2606 OID 45534)
-- Name: favorite_tasker favorite_tasker_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_tasker
    ADD CONSTRAINT favorite_tasker_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5190 (class 2606 OID 46026)
-- Name: package_variants package_variants_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_variants
    ADD CONSTRAINT package_variants_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.service_packages(id) ON DELETE CASCADE;


--
-- TOC entry 5165 (class 2606 OID 45599)
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- TOC entry 5166 (class 2606 OID 45609)
-- Name: payments payments_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5167 (class 2606 OID 45604)
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5171 (class 2606 OID 45634)
-- Name: reviews reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- TOC entry 5179 (class 2606 OID 45684)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- TOC entry 5180 (class 2606 OID 45679)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 5189 (class 2606 OID 46010)
-- Name: service_packages service_packages_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_packages
    ADD CONSTRAINT service_packages_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- TOC entry 5157 (class 2606 OID 45549)
-- Name: services services_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.service_categories(id);


--
-- TOC entry 5168 (class 2606 OID 45624)
-- Name: tasker_earnings tasker_earnings_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_earnings
    ADD CONSTRAINT tasker_earnings_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- TOC entry 5169 (class 2606 OID 45619)
-- Name: tasker_earnings tasker_earnings_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_earnings
    ADD CONSTRAINT tasker_earnings_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5170 (class 2606 OID 45629)
-- Name: tasker_payouts tasker_payouts_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_payouts
    ADD CONSTRAINT tasker_payouts_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5184 (class 2606 OID 45822)
-- Name: tasker_roles tasker_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_roles
    ADD CONSTRAINT tasker_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 5185 (class 2606 OID 45817)
-- Name: tasker_roles tasker_roles_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_roles
    ADD CONSTRAINT tasker_roles_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5158 (class 2606 OID 45559)
-- Name: tasker_services tasker_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_services
    ADD CONSTRAINT tasker_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- TOC entry 5159 (class 2606 OID 45554)
-- Name: tasker_services tasker_services_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_services
    ADD CONSTRAINT tasker_services_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5188 (class 2606 OID 45961)
-- Name: tasker_transaction tasker_transaction_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_transaction
    ADD CONSTRAINT tasker_transaction_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5178 (class 2606 OID 45669)
-- Name: tasker_unavailable_dates tasker_unavailable_dates_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_unavailable_dates
    ADD CONSTRAINT tasker_unavailable_dates_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5187 (class 2606 OID 45951)
-- Name: tasker_wallet tasker_wallet_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasker_wallet
    ADD CONSTRAINT tasker_wallet_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5160 (class 2606 OID 45564)
-- Name: user_addresses user_addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5176 (class 2606 OID 45664)
-- Name: user_preferences user_preferences_service_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_service_category_id_fkey FOREIGN KEY (service_category_id) REFERENCES public.service_categories(id);


--
-- TOC entry 5177 (class 2606 OID 45659)
-- Name: user_preferences user_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5181 (class 2606 OID 45694)
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 5182 (class 2606 OID 45689)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5191 (class 2606 OID 46069)
-- Name: user_transaction user_transaction_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_transaction
    ADD CONSTRAINT user_transaction_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5152 (class 2606 OID 45529)
-- Name: user_verifications user_verifications_tasker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_verifications
    ADD CONSTRAINT user_verifications_tasker_id_fkey FOREIGN KEY (tasker_id) REFERENCES public.tasker(id);


--
-- TOC entry 5153 (class 2606 OID 45524)
-- Name: user_verifications user_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_verifications
    ADD CONSTRAINT user_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5186 (class 2606 OID 45946)
-- Name: user_wallet user_wallet_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wallet
    ADD CONSTRAINT user_wallet_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-06-25 10:14:31

--
-- PostgreSQL database dump complete
--

