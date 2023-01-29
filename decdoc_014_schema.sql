--
-- PostgreSQL database dump
--

-- Dumped from database version 11.18 (Debian 11.18-0+deb10u1)
-- Dumped by pg_dump version 11.18 (Debian 11.18-0+deb10u1)

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
-- Name: decdoc2; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA decdoc2;


ALTER SCHEMA decdoc2 OWNER TO postgres;

--
-- Name: isbnid; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.isbnid AS character varying(13);


ALTER DOMAIN public.isbnid OWNER TO ulli;

--
-- Name: DOMAIN isbnid; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.isbnid IS 'ISBN book number';


--
-- Name: monthno; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.monthno AS integer
	CONSTRAINT monthno_check CHECK (((VALUE >= 1) AND (VALUE <= 12)));


ALTER DOMAIN public.monthno OWNER TO ulli;

--
-- Name: DOMAIN monthno; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.monthno IS 'specification of month where more precise date is unknown';


--
-- Name: pinteger; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.pinteger AS integer
	CONSTRAINT pinteger_check CHECK ((VALUE > 0));


ALTER DOMAIN public.pinteger OWNER TO ulli;

--
-- Name: DOMAIN pinteger; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.pinteger IS 'positive integer';


--
-- Name: vid; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.vid AS character varying(50);


ALTER DOMAIN public.vid OWNER TO ulli;

--
-- Name: DOMAIN vid; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.vid IS '50 character domain for ids';


--
-- Name: vidl; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.vidl AS character varying(255);


ALTER DOMAIN public.vidl OWNER TO ulli;

--
-- Name: DOMAIN vidl; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.vidl IS 'long (255) character domain for ids';


--
-- Name: yearno; Type: DOMAIN; Schema: public; Owner: ulli
--

CREATE DOMAIN public.yearno AS integer
	CONSTRAINT yearno_check CHECK (((VALUE >= 1900) AND (VALUE <= 2100)));


ALTER DOMAIN public.yearno OWNER TO ulli;

--
-- Name: DOMAIN yearno; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON DOMAIN public.yearno IS 'specification of year where more precise date is unknown';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: images; Type: TABLE; Schema: decdoc2; Owner: postgres
--

CREATE TABLE decdoc2.images (
    id character varying(255) NOT NULL,
    gallery character varying(255),
    image bytea
);


ALTER TABLE decdoc2.images OWNER TO postgres;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.authors (
    id public.vid NOT NULL,
    firstname character varying(255),
    surname character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.authors OWNER TO ulli;

--
-- Name: TABLE authors; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.authors IS 'document authors ';


--
-- Name: busses; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.busses (
    id public.vid NOT NULL,
    bus character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    CONSTRAINT ck_upper CHECK (((id)::text = upper((id)::text)))
);


ALTER TABLE public.busses OWNER TO ulli;

--
-- Name: TABLE busses; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.busses IS 'types of hardware busses ...';


--
-- Name: cddir; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.cddir (
    id_swrpac public.vid NOT NULL,
    id_cddir public.vid NOT NULL,
    doctype character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.cddir OWNER TO ulli;

--
-- Name: TABLE cddir; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.cddir IS 'CD software product directories on Software CDs';


--
-- Name: cddir_in; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.cddir_in (
    id_swrpac public.vid NOT NULL,
    id_cddir public.vid NOT NULL
);


ALTER TABLE public.cddir_in OWNER TO ulli;

--
-- Name: hwr; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr (
    id public.vid NOT NULL,
    item character varying(255),
    origin public.vid DEFAULT 'DEC'::character varying,
    hierarchylevel public.vid,
    date_introduction date,
    date_intro_sure boolean,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    detail character varying(255),
    CONSTRAINT ck_upper CHECK (((id)::text = upper((id)::text)))
);


ALTER TABLE public.hwr OWNER TO ulli;

--
-- Name: TABLE hwr; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr IS 'information common to all versions of a hardware item';


--
-- Name: codes_in_hwr; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.codes_in_hwr AS
 SELECT DISTINCT "substring"((hwr.id)::text, 1, 3) AS code
   FROM public.hwr
  WHERE ("substring"((hwr.id)::text, 3, 1) = '-'::text)
  ORDER BY ("substring"((hwr.id)::text, 1, 3));


ALTER TABLE public.codes_in_hwr OWNER TO ulli;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.countries (
    id public.vid NOT NULL,
    country character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.countries OWNER TO ulli;

--
-- Name: TABLE countries; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.countries IS 'Countries of origins (meaning firms, institutions or persons making hardware, software or publishing documents';


--
-- Name: cpupins; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.cpupins (
    pin character varying(2) NOT NULL
);


ALTER TABLE public.cpupins OWNER TO ulli;

--
-- Name: cpurows; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.cpurows (
    "row" character varying(1) NOT NULL
);


ALTER TABLE public.cpurows OWNER TO ulli;

--
-- Name: cpuslots; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.cpuslots (
    slot smallint NOT NULL
);


ALTER TABLE public.cpuslots OWNER TO ulli;

--
-- Name: import; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.import (
    id_hardware public.vid,
    variant public.vid,
    description character varying(255)
);


ALTER TABLE public.import OWNER TO ulli;

--
-- Name: d_import; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.d_import AS
 SELECT DISTINCT import.id_hardware
   FROM public.import
  ORDER BY import.id_hardware;


ALTER TABLE public.d_import OWNER TO ulli;

--
-- Name: decdoc_versions; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.decdoc_versions (
    version public.vid NOT NULL,
    release_date timestamp without time zone DEFAULT now(),
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.decdoc_versions OWNER TO ulli;

--
-- Name: TABLE decdoc_versions; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.decdoc_versions IS 'DECdoc versions and release dates';


--
-- Name: diag_import; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.diag_import (
    id public.vid,
    version public.vid,
    item character varying(255)
);


ALTER TABLE public.diag_import OWNER TO ulli;

--
-- Name: diaglevels; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.diaglevels (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.diaglevels OWNER TO ulli;

--
-- Name: TABLE diaglevels; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.diaglevels IS 'diaglevels';


--
-- Name: doc; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc (
    id public.vid NOT NULL,
    isbn public.isbnid,
    title character varying(255),
    origin public.vid DEFAULT 'DEC'::character varying,
    doctype public.vid,
    date date,
    language public.vid,
    edition public.pinteger,
    pages public.pinteger,
    papersize public.vid,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc OWNER TO ulli;

--
-- Name: TABLE doc; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc IS 'All kinds of documents and document sets, e.g binders, books, manuals, handbooks, pricelists, etc.';


--
-- Name: COLUMN doc.id; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.id IS 'document-id, preferrably (DEC) order number, otherwise number prefixed with $$_';


--
-- Name: COLUMN doc.isbn; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.isbn IS 'ISBN number (if document is a book)';


--
-- Name: COLUMN doc.title; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.title IS 'document title';


--
-- Name: COLUMN doc.origin; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.origin IS 'firm, institution or person that published the document, NOT the author(s)';


--
-- Name: COLUMN doc.doctype; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.doctype IS 'type of document, e.g. binder, book, manual, handbook, pricelist, etc.';


--
-- Name: COLUMN doc.date; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.date IS 'publication date';


--
-- Name: COLUMN doc.language; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.language IS 'language of the document';


--
-- Name: COLUMN doc.edition; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.edition IS 'edition number';


--
-- Name: COLUMN doc.pages; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.pages IS 'number of pages (including title/backpage?)';


--
-- Name: COLUMN doc.papersize; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc.papersize IS 'size of paper';


--
-- Name: doc_authors; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_authors (
    id_document public.vid NOT NULL,
    id_author public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc_authors OWNER TO ulli;

--
-- Name: TABLE doc_authors; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_authors IS 'connection between authors and their writings (who wrote what)';


--
-- Name: doc_hwr; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_hwr (
    id_document public.vid NOT NULL,
    id_hardware public.vid NOT NULL,
    rank integer,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    dependency public.vid,
    variant public.vid NOT NULL
);


ALTER TABLE public.doc_hwr OWNER TO ulli;

--
-- Name: TABLE doc_hwr; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_hwr IS 'dependencies between documents and hardware items';


--
-- Name: doc_hwrdeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_hwrdeptyp (
    dependency public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc_hwrdeptyp OWNER TO ulli;

--
-- Name: TABLE doc_hwrdeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_hwrdeptyp IS 'type of dependency between documents and hardware items';


--
-- Name: doc_owners; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_owners (
    id_document public.vid NOT NULL,
    id_owner public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    device character varying(50),
    path character varying(50),
    file character varying(255),
    condition public.pinteger,
    source character varying(50),
    form character varying(50),
    doctype character varying(50),
    docno character varying(50) DEFAULT '1'::character varying NOT NULL,
    tobe_scanned boolean DEFAULT false,
    storage public.vid,
    private boolean DEFAULT false
);


ALTER TABLE public.doc_owners OWNER TO ulli;

--
-- Name: TABLE doc_owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_owners IS 'who owns which document';


--
-- Name: COLUMN doc_owners.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.doc_owners.private IS 'privacy flag';


--
-- Name: doc_swrpac; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_swrpac (
    id_document public.vid NOT NULL,
    id_swrpac public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc_swrpac OWNER TO ulli;

--
-- Name: TABLE doc_swrpac; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_swrpac IS 'which document describes which softwarepackage or softwarepackage set';


--
-- Name: doc_swrprover; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_swrprover (
    id_document public.vid NOT NULL,
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    rank integer,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    dependency public.vid
);


ALTER TABLE public.doc_swrprover OWNER TO ulli;

--
-- Name: TABLE doc_swrprover; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_swrprover IS 'which document describes which softwareproductversion';


--
-- Name: doc_swrproverdeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_swrproverdeptyp (
    dependency public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc_swrproverdeptyp OWNER TO ulli;

--
-- Name: TABLE doc_swrproverdeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_swrproverdeptyp IS 'type of dependency between documents and softwareproduct versions';


--
-- Name: doc_worktyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doc_worktyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doc_worktyp OWNER TO ulli;

--
-- Name: TABLE doc_worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doc_worktyp IS 'types of work to be done with documents, e.g. scanning, evaluating, ...';


--
-- Name: docdep; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.docdep (
    id_superdoc public.vid NOT NULL,
    id_subdoc public.vid NOT NULL,
    dependency public.vid,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.docdep OWNER TO ulli;

--
-- Name: TABLE docdep; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.docdep IS 'dependencies between hierachically superior and inferior documents';


--
-- Name: docdeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.docdeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.docdeptyp OWNER TO ulli;

--
-- Name: TABLE docdeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.docdeptyp IS 'type of dependency between hierachically superior and inferior documents';


--
-- Name: COLUMN docdeptyp.dependency_forward; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docdeptyp.dependency_forward IS 'dependency between superior and inferior item (forward direction, that is from superior 

to inferior)';


--
-- Name: COLUMN docdeptyp.dependency_reverse; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docdeptyp.dependency_reverse IS 'dependency between inferior and superior item (reverse of forward dependency)';


--
-- Name: docown_work; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.docown_work (
    id_document public.vid NOT NULL,
    id_owner public.vid NOT NULL,
    docno character varying(50) DEFAULT '1'::character varying NOT NULL,
    pagerange public.vid DEFAULT 'all'::character varying NOT NULL,
    worktyp public.vid NOT NULL,
    workstatus public.vid DEFAULT 'to be done'::character varying,
    id_worker character varying(50) DEFAULT "current_user"(),
    private boolean DEFAULT false,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.docown_work OWNER TO ulli;

--
-- Name: TABLE docown_work; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.docown_work IS 'work to be done with documents';


--
-- Name: COLUMN docown_work.pagerange; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docown_work.pagerange IS 'range of pages to be worked on';


--
-- Name: COLUMN docown_work.worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docown_work.worktyp IS 'type of work to be done';


--
-- Name: COLUMN docown_work.workstatus; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docown_work.workstatus IS 'status of work to be done';


--
-- Name: COLUMN docown_work.id_worker; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docown_work.id_worker IS 'person charged to do the work';


--
-- Name: COLUMN docown_work.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.docown_work.private IS 'privacy flag';


--
-- Name: doctyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.doctyp (
    id public.vid NOT NULL,
    doctype character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.doctyp OWNER TO ulli;

--
-- Name: TABLE doctyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.doctyp IS 'document types, e.g binder sets, binders, manuals, books, handbooks, ...';


--
-- Name: drawingcode; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.drawingcode (
    id_drawingcode public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.drawingcode OWNER TO ulli;

--
-- Name: TABLE drawingcode; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.drawingcode IS 'first two digits of DEC drawing numbers';


--
-- Name: hwr_busses; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_busses (
    id_hardware public.vid NOT NULL,
    id_bus public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwr_busses OWNER TO ulli;

--
-- Name: TABLE hwr_busses; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_busses IS 'which hardware items have got which busses';


--
-- Name: hwr_code; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_code (
    id_hwrcode public.vid NOT NULL,
    description character varying(1000),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwr_code OWNER TO ulli;

--
-- Name: TABLE hwr_code; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_code IS 'first two digits of DEC part numbers';


--
-- Name: hwr_config; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_config (
    id_superhardware public.vid NOT NULL,
    supervariant public.vid NOT NULL,
    id_subhardware public.vid NOT NULL,
    subvariant public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    superserialno public.vid NOT NULL,
    subserialno public.vid NOT NULL,
    configno public.vid NOT NULL,
    box public.vid,
    backplane public.vid,
    slot public.vid,
    private boolean DEFAULT false
);


ALTER TABLE public.hwr_config OWNER TO ulli;

--
-- Name: TABLE hwr_config; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_config IS 'owners sub hardware item variant configured into owners super hardware item variant';


--
-- Name: COLUMN hwr_config.box; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwr_config.box IS 'system box the hardware item is configured in';


--
-- Name: COLUMN hwr_config.backplane; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwr_config.backplane IS 'backplane the module is configured in';


--
-- Name: COLUMN hwr_config.slot; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwr_config.slot IS 'slot of the backplane the module is configured in';


--
-- Name: COLUMN hwr_config.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwr_config.private IS 'privacy flag';


--
-- Name: hwr_hwrfunction; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_hwrfunction (
    hardware public.vid NOT NULL,
    function public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwr_hwrfunction OWNER TO ulli;

--
-- Name: TABLE hwr_hwrfunction; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_hwrfunction IS 'functions of a hardware item (modules sometimes have more than one function)';


--
-- Name: hwr_noitem; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.hwr_noitem AS
 SELECT hwr.id,
    hwr.item,
    hwr.origin,
    hwr.hierarchylevel,
    hwr.date_introduction,
    hwr.date_intro_sure,
    hwr.created_datetime,
    hwr.created_by,
    hwr.modified_datetime,
    hwr.modified_by,
    hwr.remark,
    hwr.flag
   FROM public.hwr
  WHERE (hwr.item IS NULL);


ALTER TABLE public.hwr_noitem OWNER TO ulli;

--
-- Name: hwr_tests; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_tests (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    private boolean DEFAULT false
);


ALTER TABLE public.hwr_tests OWNER TO ulli;

--
-- Name: TABLE hwr_tests; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_tests IS 'types of tests performed on specific hardware item variants';


--
-- Name: hwr_upper; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.hwr_upper AS
 SELECT upper((hwr.item)::text) AS upper,
    hwr.id,
    hwr.item,
    hwr.origin,
    hwr.hierarchylevel,
    hwr.date_introduction,
    hwr.date_intro_sure,
    hwr.created_datetime,
    hwr.created_by,
    hwr.modified_datetime,
    hwr.modified_by,
    hwr.remark,
    hwr.flag
   FROM public.hwr;


ALTER TABLE public.hwr_upper OWNER TO ulli;

--
-- Name: hwr_worktyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwr_worktyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwr_worktyp OWNER TO ulli;

--
-- Name: TABLE hwr_worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwr_worktyp IS 'types of work to be done with hardware, e.g. cleaning, testing, ...';


--
-- Name: hwrfunction; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrfunction (
    id public.vid NOT NULL,
    function character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrfunction OWNER TO ulli;

--
-- Name: TABLE hwrfunction; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrfunction IS 'Describes what a hardware item does, e.g. Disk Array, Disk Cartridge, Disk Pack, Disk, ...';


--
-- Name: hwrown_work; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrown_work (
    id_hwr public.vid NOT NULL,
    id_variant public.vid NOT NULL,
    serialno public.vid NOT NULL,
    worktyp public.vid,
    workstatus public.vid DEFAULT 'to be done'::character varying,
    id_worker character varying(50) DEFAULT "current_user"(),
    private boolean DEFAULT false,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrown_work OWNER TO ulli;

--
-- Name: TABLE hwrown_work; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrown_work IS 'work to be done with hardware';


--
-- Name: COLUMN hwrown_work.worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrown_work.worktyp IS 'type of work to be done';


--
-- Name: COLUMN hwrown_work.workstatus; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrown_work.workstatus IS 'status of work to be done';


--
-- Name: COLUMN hwrown_work.id_worker; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrown_work.id_worker IS 'person charged to do the work';


--
-- Name: COLUMN hwrown_work.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrown_work.private IS 'privacy flag';


--
-- Name: hwrtyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrtyp (
    id public.vid NOT NULL,
    hierarchylevel character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrtyp OWNER TO ulli;

--
-- Name: TABLE hwrtyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrtyp IS 'type of hardware, e.g. architecture/series/system/model/device/option/assembly/part';


--
-- Name: hwrvar; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvar (
    id_hardware public.vid NOT NULL,
    variant public.vid DEFAULT '00'::character varying NOT NULL,
    description character varying(255),
    card_width integer,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrvar OWNER TO ulli;

--
-- Name: TABLE hwrvar; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvar IS 'hardware item variants';


--
-- Name: hwrvar_owners; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvar_owners (
    id_hardware public.vid NOT NULL,
    variant public.vid NOT NULL,
    id_owner public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    serialno public.vid NOT NULL,
    revision public.vid,
    rom_version public.vid,
    mac public.vid,
    description character varying(255),
    storage public.vid,
    acquired_from public.vid,
    acquired_date date,
    tested_date date,
    tested_result character varying(255),
    tested_comment character varying(255),
    given_to public.vid,
    given_date date,
    acquired_price public.vid,
    given_price public.vid,
    nodename public.vid,
    private boolean DEFAULT false,
    museum_no public.vid,
    www character varying(255)
);


ALTER TABLE public.hwrvar_owners OWNER TO ulli;

--
-- Name: TABLE hwrvar_owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvar_owners IS 'who owns which hardware item variant';


--
-- Name: COLUMN hwrvar_owners.nodename; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvar_owners.nodename IS 'nodename - to be used with systems or named network devices only';


--
-- Name: COLUMN hwrvar_owners.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvar_owners.private IS 'privacy flag';


--
-- Name: hwrvar_rev; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvar_rev (
    id_hardware public.vid NOT NULL,
    variant public.vid NOT NULL,
    revision public.vid NOT NULL,
    changeno public.vid NOT NULL,
    date timestamp without time zone,
    docref public.vid,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrvar_rev OWNER TO ulli;

--
-- Name: TABLE hwrvar_rev; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvar_rev IS 'hardware variants and associated revisions (usually found in MP drawing directories DD)';


--
-- Name: hwrvar_val; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvar_val (
    id_hardware public.vid NOT NULL,
    variant public.vid NOT NULL,
    id_valtyp public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    valuenumber real,
    unit public.vid NOT NULL,
    docref public.vid,
    docrefpage public.vid
);


ALTER TABLE public.hwrvar_val OWNER TO ulli;

--
-- Name: TABLE hwrvar_val; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvar_val IS 'hardware variants and associated values (made from value numbers and value types/units)';


--
-- Name: hwrvardep; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvardep (
    id_superhardware public.vid NOT NULL,
    supervariant public.vid NOT NULL,
    id_subhardware public.vid NOT NULL,
    subvariant public.vid NOT NULL,
    dependency public.vid NOT NULL,
    subcount_mandatory public.pinteger,
    subcount_optional public.pinteger,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrvardep OWNER TO ulli;

--
-- Name: TABLE hwrvardep; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvardep IS 'assemblies consisting of hierarchically superior and inferior hardware item variants';


--
-- Name: COLUMN hwrvardep.subcount_mandatory; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvardep.subcount_mandatory IS 'number of mandatory identical hardwarevariant subitems';


--
-- Name: COLUMN hwrvardep.subcount_optional; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvardep.subcount_optional IS 'number of optional identical hardwarevariant subitems';


--
-- Name: hwrvardeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvardeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.hwrvardeptyp OWNER TO ulli;

--
-- Name: TABLE hwrvardeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvardeptyp IS 'type of dependency between hierachically superior and inferior hardwarevariant items';


--
-- Name: COLUMN hwrvardeptyp.dependency_forward; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvardeptyp.dependency_forward IS 'description of dependency between superior and inferior item (forward direction, that is from superior to inferior)';


--
-- Name: COLUMN hwrvardeptyp.dependency_reverse; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.hwrvardeptyp.dependency_reverse IS 'description of dependency between inferior and superior item (reverse of forward dependency)';


--
-- Name: hwrvarown_tests; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.hwrvarown_tests (
    id_hardware public.vid NOT NULL,
    variant public.vid NOT NULL,
    serialno public.vid NOT NULL,
    test_date date DEFAULT now() NOT NULL,
    test_no public.pinteger NOT NULL,
    id_test public.vid NOT NULL,
    test_subtype public.vid DEFAULT '-'::character varying NOT NULL,
    test_result character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    private boolean DEFAULT false
);


ALTER TABLE public.hwrvarown_tests OWNER TO ulli;

--
-- Name: TABLE hwrvarown_tests; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.hwrvarown_tests IS 'tests and results performed on specific hardware item variants';


--
-- Name: kits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kits (
    id public.vid NOT NULL,
    kit character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.kits OWNER TO postgres;

--
-- Name: kitstyp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kitstyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.kitstyp OWNER TO postgres;

--
-- Name: kitsvar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kitsvar (
    id_kit public.vid NOT NULL,
    variant character varying(50) DEFAULT '00'::character varying NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.kitsvar OWNER TO postgres;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.languages (
    id public.vid NOT NULL,
    language character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.languages OWNER TO ulli;

--
-- Name: TABLE languages; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.languages IS 'languages used in documents';


--
-- Name: lic; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.lic (
    id_softwareproduct public.vid NOT NULL,
    id_softwarelicense public.vid NOT NULL,
    version public.vid NOT NULL,
    units public.pinteger NOT NULL,
    availability character varying(1) NOT NULL,
    activity character varying(1) NOT NULL,
    keyoptions character varying(50) NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.lic OWNER TO ulli;

--
-- Name: TABLE lic; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.lic IS 'DEC PAK licenses (VMS >= V5.0); older licenses see table swrpro (swrprotyp = "lic" = license key kit)';


--
-- Name: lic_input; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.lic_input (
    issuer public.vid,
    auth public.vid NOT NULL,
    product public.vid,
    producer public.vid,
    units public.vid,
    version public.vid,
    date public.vid,
    termination public.vid,
    availability public.vid,
    activity public.vid,
    options public.vid,
    token public.vid,
    checksum public.vid,
    source public.vid,
    flag public.vid
);


ALTER TABLE public.lic_input OWNER TO ulli;

--
-- Name: lic_owners; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.lic_owners (
    id_owner public.vid NOT NULL,
    private boolean DEFAULT false,
    authno public.vid NOT NULL,
    checksum public.vid,
    id_softwareproduct public.vid,
    id_softwarelicense public.vid,
    version public.vid DEFAULT '0.0'::character varying,
    units public.pinteger,
    availability character varying(1),
    activity character varying(1),
    keyoptions character varying(50),
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    issuer public.vid,
    producer public.vid,
    release public.vid,
    termination public.vid,
    token public.vid
);


ALTER TABLE public.lic_owners OWNER TO ulli;

--
-- Name: TABLE lic_owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.lic_owners IS 'DEC PAK licenses and their owners; older licenses & owners see table swrproverswrpac_owners';


--
-- Name: COLUMN lic_owners.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.lic_owners.private IS 'privacy flag';


--
-- Name: licpro; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.licpro (
    id public.vid NOT NULL,
    item character varying(255),
    origin public.vid,
    hierarchylevel public.vid,
    date_introduction date,
    date_intro_sure boolean,
    created_datetime timestamp without time zone,
    created_by character varying(50),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.licpro OWNER TO ulli;

--
-- Name: licprovar; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.licprovar (
    id_licpro public.vid NOT NULL,
    variant public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone,
    created_by character varying(50),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    units integer
);


ALTER TABLE public.licprovar OWNER TO ulli;

--
-- Name: long; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.long AS
 SELECT hwr.id,
    hwr.item,
    hwr.origin,
    hwr.hierarchylevel,
    hwr.date_introduction,
    hwr.date_intro_sure,
    hwr.created_datetime,
    hwr.created_by,
    hwr.modified_datetime,
    hwr.modified_by,
    hwr.remark,
    hwr.flag,
    hwr.detail
   FROM public.hwr
  WHERE ((hwr.id)::text IN ( SELECT hwr_1.id
           FROM public.hwr hwr_1
          WHERE (length((hwr_1.item)::text) > 80)));


ALTER TABLE public.long OWNER TO ulli;

--
-- Name: longid; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.longid AS
 SELECT hwr.id,
    hwr.item,
    hwr.origin,
    hwr.hierarchylevel,
    hwr.date_introduction,
    hwr.date_intro_sure,
    hwr.created_datetime,
    hwr.created_by,
    hwr.modified_datetime,
    hwr.modified_by,
    hwr.remark,
    hwr.flag,
    hwr.detail
   FROM public.hwr
  WHERE ((hwr.id)::text IN ( SELECT hwr_1.id
           FROM public.hwr hwr_1
          WHERE (length((hwr_1.id)::text) > 30)));


ALTER TABLE public.longid OWNER TO ulli;

--
-- Name: manual; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.manual AS
 SELECT ((hwrvar.id_hardware)::text || (hwrvar.variant)::text) AS id,
    replace((hwrvar.description)::text, ''''::text, ''::text) AS title
   FROM public.hwrvar
  WHERE ((hwrvar.id_hardware)::text ~~ 'AA-%'::text);


ALTER TABLE public.manual OWNER TO ulli;

--
-- Name: newhwr; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.newhwr AS
 SELECT import.id_hardware,
    import.variant,
    import.description
   FROM (public.import
     LEFT JOIN public.hwr ON (((import.id_hardware)::text = (hwr.id)::text)))
  WHERE (hwr.id IS NULL);


ALTER TABLE public.newhwr OWNER TO ulli;

--
-- Name: nullnull; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.nullnull AS
 SELECT hwrvar.id_hardware
   FROM public.hwrvar
  WHERE ((hwrvar.variant)::text = '-00'::text);


ALTER TABLE public.nullnull OWNER TO ulli;

--
-- Name: novariant; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.novariant AS
 SELECT hwr.id
   FROM (public.hwr
     LEFT JOIN public.nullnull ON (((hwr.id)::text = (nullnull.id_hardware)::text)))
  WHERE (nullnull.id_hardware IS NULL);


ALTER TABLE public.novariant OWNER TO ulli;

--
-- Name: origins; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.origins (
    id public.vid NOT NULL,
    origin character varying(255),
    country public.vid,
    www character varying(255),
    email character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.origins OWNER TO ulli;

--
-- Name: TABLE origins; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.origins IS 'firms, institutions or persons making hardware, software or publishing documents - NO authors';


--
-- Name: owners; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.owners (
    id public.vid NOT NULL,
    firstname character varying(255),
    surname character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    www character varying(255),
    museum boolean DEFAULT false
);


ALTER TABLE public.owners OWNER TO ulli;

--
-- Name: TABLE owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.owners IS 'owners of hardwarevariants, softwareversions, diagnosticversions, documents, ...';


--
-- Name: papersizes; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.papersizes (
    id public.vid NOT NULL,
    papersize character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.papersizes OWNER TO ulli;

--
-- Name: TABLE papersizes; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.papersizes IS 'paper sizes used in documents and drawings';


--
-- Name: pins; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.pins (
    pin character varying(6) NOT NULL
);


ALTER TABLE public.pins OWNER TO ulli;

--
-- Name: plantcode; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.plantcode (
    id_plantcode public.vid NOT NULL,
    id_sid public.vid NOT NULL,
    location character varying(50),
    state character varying(50),
    country character varying(50),
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.plantcode OWNER TO ulli;

--
-- Name: TABLE plantcode; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.plantcode IS 'DEC plant codes and related SIDs';


--
-- Name: qinput; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.qinput (
    id public.vid,
    item character varying(255)
);


ALTER TABLE public.qinput OWNER TO ulli;

--
-- Name: storages; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.storages (
    id public.vid NOT NULL,
    id_owner public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    private boolean DEFAULT false
);


ALTER TABLE public.storages OWNER TO ulli;

--
-- Name: TABLE storages; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.storages IS 'owner specific storage locations';


--
-- Name: COLUMN storages.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.storages.private IS 'privacy flag';


--
-- Name: summe_datensatz; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.summe_datensatz AS
 SELECT sum(pg_class.reltuples) AS summe_datensaetze
   FROM (pg_class
     LEFT JOIN pg_namespace ON ((pg_namespace.oid = pg_class.relnamespace)))
  WHERE ((pg_namespace.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (pg_class.relkind = 'r'::"char"));


ALTER TABLE public.summe_datensatz OWNER TO ulli;

--
-- Name: swr_worktyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swr_worktyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swr_worktyp OWNER TO ulli;

--
-- Name: TABLE swr_worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swr_worktyp IS 'types of work to be done with software, e.g. imaging, ...';


--
-- Name: swrformat; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrformat (
    id public.vid NOT NULL,
    softwareformat character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrformat OWNER TO ulli;

--
-- Name: TABLE swrformat; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrformat IS 'file formats, e.g. files-11, ods1, ods2, saveset, dump, tar, ...';


--
-- Name: swrmedia; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrmedia (
    id public.vid NOT NULL,
    softwaremedium character varying(255),
    dec_shortcut character varying(50),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrmedia OWNER TO ulli;

--
-- Name: TABLE swrmedia; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrmedia IS 'media types like e.g. MT1600, RK07, RL02, RX50, RA60, ...';


--
-- Name: swrpac; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpac (
    id public.vid NOT NULL,
    name character varying(255),
    softwarepackagetype public.vid,
    volumelabel character varying(50),
    softwareformat public.vid,
    bootable boolean,
    softwaremedium public.vid,
    copyright character varying(50),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    releasedate character varying(20),
    rdate date
);


ALTER TABLE public.swrpac OWNER TO ulli;

--
-- Name: TABLE swrpac; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpac IS 'Softwareproducts stored on media, either media sets, single media (one or more packages), or single packages';


--
-- Name: swrpac_owners; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpac_owners (
    id_swrpac public.vid NOT NULL,
    swrpacno public.vid DEFAULT 1 NOT NULL,
    id_owner public.vid DEFAULT 'Ulli'::character varying NOT NULL,
    private boolean DEFAULT false,
    storage public.vid,
    device character varying(50),
    path character varying(50),
    file character varying(255),
    tobe_imaged boolean DEFAULT false,
    incomplete boolean DEFAULT false,
    softwaremedium public.vid,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpac_owners OWNER TO ulli;

--
-- Name: TABLE swrpac_owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpac_owners IS 'who owns which software packages';


--
-- Name: COLUMN swrpac_owners.swrpacno; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpac_owners.swrpacno IS 'number to distinguish between different instances of identical softwarepackages belonging to an owner, e.g. two identical CDs';


--
-- Name: COLUMN swrpac_owners.private; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpac_owners.private IS 'privacy flag';


--
-- Name: COLUMN swrpac_owners.softwaremedium; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpac_owners.softwaremedium IS 'different media owners store software product versions on (as compared to DEC)';


--
-- Name: swrpac_worktyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpac_worktyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpac_worktyp OWNER TO ulli;

--
-- Name: TABLE swrpac_worktyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpac_worktyp IS 'work to be done with software packages, e.g. imaging, backing up, ...';


--
-- Name: swrpacdep; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpacdep (
    id_supersoftwarepackage public.vid NOT NULL,
    id_subsoftwarepackage public.vid NOT NULL,
    dependency public.vid,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpacdep OWNER TO ulli;

--
-- Name: TABLE swrpacdep; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpacdep IS 'Software package assemblies consisting of hierarchically superior and inferior software packages';


--
-- Name: swrpacdeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpacdeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpacdeptyp OWNER TO ulli;

--
-- Name: TABLE swrpacdeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpacdeptyp IS 'type of dependency between superior and inferior softwarepackage';


--
-- Name: COLUMN swrpacdeptyp.dependency_forward; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpacdeptyp.dependency_forward IS 'relation between superior and inferior item (forward direction, that is from superior to 

inferior)';


--
-- Name: COLUMN swrpacdeptyp.dependency_reverse; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpacdeptyp.dependency_reverse IS 'relation between inferior and superior item (reverse of forward dependency)';


--
-- Name: swrpactyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpactyp (
    id public.vid NOT NULL,
    softwarepackagetype character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpactyp OWNER TO ulli;

--
-- Name: TABLE swrpactyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpactyp IS 'Software package type; currently one of: media set, (single) medium, (single) software, filegroup, (single) file';


--
-- Name: swrpro; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpro (
    id public.vid NOT NULL,
    type public.vid,
    item character varying(255),
    origin public.vid DEFAULT 'DEC'::character varying,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    spd public.vid,
    upi public.vid,
    crossref public.vid,
    diaglevel public.vid,
    upi_cc public.vid DEFAULT 'AA'::character varying,
    os public.vid,
    arch public.vid,
    item2 character varying(255),
    short public.vid,
    instname public.vid,
    CONSTRAINT ck_upper CHECK (((id)::text = upper((id)::text)))
);


ALTER TABLE public.swrpro OWNER TO ulli;

--
-- Name: TABLE swrpro; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpro IS 'softwareproducts like VMS, RT-11, VAX-BASIC, DECnet-RSX, ...';


--
-- Name: COLUMN swrpro.upi_cc; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpro.upi_cc IS 'unique product identifier country code';


--
-- Name: COLUMN swrpro.os; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpro.os IS 'operating system for softwareproduct';


--
-- Name: COLUMN swrpro.arch; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrpro.arch IS 'hardware architecture for softwareproduct';


--
-- Name: swrpro_swrlic; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpro_swrlic (
    id_softwareproduct public.vid NOT NULL,
    id_softwarelicense public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrpro_swrlic OWNER TO ulli;

--
-- Name: TABLE swrpro_swrlic; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrpro_swrlic IS 'licensetypes for softwareproducts';


--
-- Name: swrpro_upi; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrpro_upi (
    id_swrpro public.vid NOT NULL,
    item character varying(255),
    origin public.vid,
    created_datetime timestamp without time zone,
    created_by character varying(50),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    upi public.vid NOT NULL
);


ALTER TABLE public.swrpro_upi OWNER TO ulli;

--
-- Name: swrprotyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprotyp (
    id public.vid NOT NULL,
    type character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrprotyp OWNER TO ulli;

--
-- Name: TABLE swrprotyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprotyp IS 'softwareproduct types like diagnostic, operating system, programming language, ...';


--
-- Name: swrprover; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover (
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    status public.vid,
    spd public.vid,
    crossref public.vid,
    nickname character varying(255),
    date_intro_sure boolean,
    year_intro public.yearno,
    month_intro public.monthno,
    instname public.vid
);


ALTER TABLE public.swrprover OWNER TO ulli;

--
-- Name: TABLE swrprover; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprover IS 'versions of softwareproducts like VMS V2.0, VMS V2.5, VMS V4.3, ...';


--
-- Name: swrprover_hwrvar; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_hwrvar (
    id_hardware public.vid NOT NULL,
    variant public.vid NOT NULL,
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    first_last character varying(1),
    support_type public.vid,
    dependency public.vid
);


ALTER TABLE public.swrprover_hwrvar OWNER TO ulli;

--
-- Name: TABLE swrprover_hwrvar; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprover_hwrvar IS 'which softwareproductversion supports which hardwarevariant';


--
-- Name: swrprover_hwrvardeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_hwrvardeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrprover_hwrvardeptyp OWNER TO ulli;

--
-- Name: TABLE swrprover_hwrvardeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprover_hwrvardeptyp IS 'dependency between softwareproductversion and hardwarevariant';


--
-- Name: COLUMN swrprover_hwrvardeptyp.dependency_forward; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrprover_hwrvardeptyp.dependency_forward IS 'description of relation between softwareproductversion and hardwarevariant (forward direction, that is from software to hardware)';


--
-- Name: COLUMN swrprover_hwrvardeptyp.dependency_reverse; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrprover_hwrvardeptyp.dependency_reverse IS 'description of relation between hardwarevariant and softwareproductversion (reverse of forward dependency)';


--
-- Name: swrprover_licprovar; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_licprovar (
    id_licpro public.vid NOT NULL,
    variant public.vid NOT NULL,
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    created_datetime timestamp without time zone,
    created_by character varying(50),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    first_last character varying(1),
    support_type public.vid,
    dependency public.vid
);


ALTER TABLE public.swrprover_licprovar OWNER TO ulli;

--
-- Name: swrprover_licprovardeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_licprovardeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid,
    description character varying(255),
    created_datetime timestamp without time zone,
    created_by character varying(50),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrprover_licprovardeptyp OWNER TO ulli;

--
-- Name: swrprover_swrpac; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_swrpac (
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    id_swrpac public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50),
    directory public.vid,
    language public.vid NOT NULL
);


ALTER TABLE public.swrprover_swrpac OWNER TO ulli;

--
-- Name: TABLE swrprover_swrpac; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprover_swrpac IS 'software product versions available in software packages';


--
-- Name: COLUMN swrprover_swrpac.directory; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrprover_swrpac.directory IS 'directory if medium has directories';


--
-- Name: swrprover_val; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrprover_val (
    id_softwareproduct public.vid NOT NULL,
    version public.vid NOT NULL,
    id_valtyp public.vid NOT NULL,
    valuenumber real,
    unit public.vid NOT NULL,
    docref public.vid,
    docrefpage public.vid,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrprover_val OWNER TO ulli;

--
-- Name: TABLE swrprover_val; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrprover_val IS 'softwareproduct versions and associated values (made from value numbers and value types/units)';


--
-- Name: swrproverdep; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrproverdep (
    id_superswrprover public.vid NOT NULL,
    superversion public.vid NOT NULL,
    id_subswrprover public.vid NOT NULL,
    subversion public.vid NOT NULL,
    dependency public.vid,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrproverdep OWNER TO ulli;

--
-- Name: TABLE swrproverdep; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrproverdep IS 'dependencies between hierachically superior and inferior softwareproductversions';


--
-- Name: swrproverdeptyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.swrproverdeptyp (
    dependency_forward public.vid NOT NULL,
    dependency_reverse public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.swrproverdeptyp OWNER TO ulli;

--
-- Name: TABLE swrproverdeptyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.swrproverdeptyp IS 'type of dependency between hierachically superior and inferior softwareproductversions';


--
-- Name: COLUMN swrproverdeptyp.dependency_forward; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrproverdeptyp.dependency_forward IS 'description of dependency between superior and inferior item (forward direction, that is from superior to inferior)';


--
-- Name: COLUMN swrproverdeptyp.dependency_reverse; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON COLUMN public.swrproverdeptyp.dependency_reverse IS 'description of dependency between inferior and superior item (reverse of forward dependency)';


--
-- Name: temp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.temp (
    id_hardware public.vid,
    variant public.vid
);


ALTER TABLE public.temp OWNER TO ulli;

--
-- Name: test; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.test (
    result text
);


ALTER TABLE public.test OWNER TO ulli;

--
-- Name: units; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.units (
    id public.vid NOT NULL,
    unit character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.units OWNER TO ulli;

--
-- Name: TABLE units; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.units IS 'units for values (but independent from value types), e.g. unit A (= Ampere) for current';


--
-- Name: valtyp_unit; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.valtyp_unit (
    valtyp public.vid NOT NULL,
    description character varying(255),
    unit public.vid NOT NULL,
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.valtyp_unit OWNER TO ulli;

--
-- Name: TABLE valtyp_unit; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.valtyp_unit IS 'combined value types and units, e.g. supply voltage (unit volt), max. memory (unit KB) or max. memory (unit MB)';


--
-- Name: valtypes; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.valtypes (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.valtypes OWNER TO ulli;

--
-- Name: TABLE valtypes; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.valtypes IS 'value types (independent from units), e.g. voltage, current or maximum memory supported';


--
-- Name: vr_hwrvar_owners; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.vr_hwrvar_owners AS
 SELECT hwrvar_owners.id_hardware,
    hwrvar_owners.variant,
    hwrvar_owners.id_owner,
    hwrvar_owners.private,
    hwrvar_owners.serialno,
    hwrvar_owners.revision,
    hwrvar_owners.rom_version,
    hwrvar_owners.mac,
    hwrvar_owners.description,
    hwrvar_owners.storage,
    hwrvar_owners.acquired_from,
    hwrvar_owners.acquired_date,
    hwrvar_owners.acquired_price,
    hwrvar_owners.tested_date,
    hwrvar_owners.tested_result,
    hwrvar_owners.tested_comment,
    hwrvar_owners.given_to,
    hwrvar_owners.given_date,
    hwrvar_owners.given_price,
    hwrvar_owners.created_datetime,
    hwrvar_owners.created_by,
    hwrvar_owners.modified_datetime,
    hwrvar_owners.modified_by,
    hwrvar_owners.remark,
    hwrvar_owners.flag
   FROM public.hwrvar_owners
  WHERE (((hwrvar_owners.created_by)::name = "current_user"()) OR (hwrvar_owners.private = false));


ALTER TABLE public.vr_hwrvar_owners OWNER TO ulli;

--
-- Name: VIEW vr_hwrvar_owners; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON VIEW public.vr_hwrvar_owners IS 'readonly view showing owners and public hwrvar_owners records only';


--
-- Name: vr_modules; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.vr_modules AS
 SELECT hwr.id,
    hwr.item,
    hwr.hierarchylevel
   FROM public.hwr
  WHERE ((hwr.id)::text ~ similar_escape('[A-Z][0-9]+%'::text, NULL::text))
  ORDER BY hwr.id;


ALTER TABLE public.vr_modules OWNER TO ulli;

--
-- Name: VIEW vr_modules; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON VIEW public.vr_modules IS 'VIEW showing only DEC modules (selected with regex)';


--
-- Name: vr_swrproverswrpac_owners; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.vr_swrproverswrpac_owners AS
 SELECT swrprover_swrpac.id_softwareproduct,
    swrprover_swrpac.version,
    swrpac.name,
    swrpac_owners.id_swrpac,
    swrpac_owners.id_owner,
    swrpac_owners.private,
    swrpac_owners.swrpacno,
    swrpac_owners.storage,
    swrpac_owners.device,
    swrpac_owners.path,
    swrpac_owners.file,
    swrpac_owners.tobe_imaged,
    swrpac_owners.incomplete,
    swrpac_owners.softwaremedium,
    swrpac_owners.description,
    swrpac_owners.remark,
    swrpac_owners.flag
   FROM public.swrprover_swrpac,
    public.swrpac,
    public.swrpac_owners
  WHERE (((swrprover_swrpac.id_swrpac)::text = (swrpac_owners.id_swrpac)::text) AND ((swrpac.id)::text = (swrpac_owners.id_swrpac)::text));


ALTER TABLE public.vr_swrproverswrpac_owners OWNER TO ulli;

--
-- Name: wires2; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.wires2 (
    id_backp smallint NOT NULL,
    id_wire smallint NOT NULL,
    pin_from character varying(6) NOT NULL,
    pin_to character varying(6) NOT NULL,
    remarks character varying(240),
    CONSTRAINT ck_diffwires CHECK (((pin_from)::text <> (pin_to)::text)),
    CONSTRAINT ck_pins_reversed CHECK (((("substring"((pin_from)::text, 2, 2) || "substring"((pin_from)::text, 1, 1)) || "substring"((pin_from)::text, 5, 2)) < (("substring"((pin_to)::text, 2, 2) || "substring"((pin_to)::text, 1, 1)) || "substring"((pin_to)::text, 5, 2))))
);


ALTER TABLE public.wires2 OWNER TO ulli;

--
-- Name: wirepins_all; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.wirepins_all AS
 SELECT wires2.pin_from AS p_from,
    wires2.pin_to AS p_to,
    wires2.id_wire
   FROM public.wires2
UNION
 SELECT wires2.pin_to AS p_from,
    wires2.pin_from AS p_to,
    wires2.id_wire
   FROM public.wires2;


ALTER TABLE public.wirepins_all OWNER TO ulli;

--
-- Name: wirepins_ordered; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.wirepins_ordered AS
 SELECT wirepins_all.p_from,
    wirepins_all.p_to,
    wirepins_all.id_wire
   FROM public.wirepins_all
  ORDER BY (("substring"((wirepins_all.p_from)::text, 2, 2) || "substring"((wirepins_all.p_from)::text, 1, 1)) || "substring"((wirepins_all.p_from)::text, 5, 2));


ALTER TABLE public.wirepins_ordered OWNER TO ulli;

--
-- Name: wirepins_reverse; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.wirepins_reverse AS
 SELECT wires2.pin_from AS "from",
    wires2.pin_to AS "to"
   FROM public.wires2
INTERSECT
 SELECT wires2.pin_to AS "from",
    wires2.pin_from AS "to"
   FROM public.wires2;


ALTER TABLE public.wirepins_reverse OWNER TO ulli;

--
-- Name: workstatustyp; Type: TABLE; Schema: public; Owner: ulli
--

CREATE TABLE public.workstatustyp (
    id public.vid NOT NULL,
    description character varying(255),
    created_datetime timestamp without time zone DEFAULT now(),
    created_by character varying(50) DEFAULT "current_user"(),
    modified_datetime timestamp without time zone,
    modified_by character varying(50),
    remark character varying(255),
    flag character varying(50)
);


ALTER TABLE public.workstatustyp OWNER TO ulli;

--
-- Name: TABLE workstatustyp; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON TABLE public.workstatustyp IS 'status of work to be done, e.g. to be done, started, finished, ...';


--
-- Name: zahl_datensatz; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.zahl_datensatz AS
 SELECT pg_class.relname AS tabelle,
    pg_class.reltuples AS anzahl_datensaetze
   FROM (pg_class
     LEFT JOIN pg_namespace ON ((pg_namespace.oid = pg_class.relnamespace)))
  WHERE ((pg_namespace.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (pg_class.relkind = 'r'::"char"))
  ORDER BY pg_class.reltuples DESC;


ALTER TABLE public.zahl_datensatz OWNER TO ulli;

--
-- Name: zahl_tabellen; Type: VIEW; Schema: public; Owner: ulli
--

CREATE VIEW public.zahl_tabellen AS
 SELECT count(*) AS anzahl_tabellen
   FROM pg_tables
  WHERE ((pg_tables.schemaname <> 'pg_catalog'::name) AND (pg_tables.schemaname <> 'information_schema'::name));


ALTER TABLE public.zahl_tabellen OWNER TO ulli;

--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: decdoc2; Owner: postgres
--

ALTER TABLE ONLY decdoc2.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: cpupins cpupins_pkey; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.cpupins
    ADD CONSTRAINT cpupins_pkey PRIMARY KEY (pin);


--
-- Name: cpurows cpurows_pkey; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.cpurows
    ADD CONSTRAINT cpurows_pkey PRIMARY KEY ("row");


--
-- Name: cpuslots cpuslots_pkey; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.cpuslots
    ADD CONSTRAINT cpuslots_pkey PRIMARY KEY (slot);


--
-- Name: authors pk_authors; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT pk_authors PRIMARY KEY (id);


--
-- Name: busses pk_busses; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.busses
    ADD CONSTRAINT pk_busses PRIMARY KEY (id);


--
-- Name: cddir pk_cddir; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.cddir
    ADD CONSTRAINT pk_cddir PRIMARY KEY (id_swrpac, id_cddir);


--
-- Name: countries pk_countries; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT pk_countries PRIMARY KEY (id);


--
-- Name: decdoc_versions pk_decdoc_versions; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.decdoc_versions
    ADD CONSTRAINT pk_decdoc_versions PRIMARY KEY (version);


--
-- Name: diaglevels pk_diaglevels; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.diaglevels
    ADD CONSTRAINT pk_diaglevels PRIMARY KEY (id);


--
-- Name: doc pk_doc; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc
    ADD CONSTRAINT pk_doc PRIMARY KEY (id);


--
-- Name: doc_authors pk_doc_authors; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_authors
    ADD CONSTRAINT pk_doc_authors PRIMARY KEY (id_document, id_author);


--
-- Name: doc_hwrdeptyp pk_doc_hwrdeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_hwrdeptyp
    ADD CONSTRAINT pk_doc_hwrdeptyp PRIMARY KEY (dependency);


--
-- Name: doc_hwr pk_doc_hwrvar; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_hwr
    ADD CONSTRAINT pk_doc_hwrvar PRIMARY KEY (id_document, id_hardware, variant);


--
-- Name: doc_owners pk_doc_owners; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_owners
    ADD CONSTRAINT pk_doc_owners PRIMARY KEY (id_owner, id_document, docno);


--
-- Name: doc_swrpac pk_doc_swrpac; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrpac
    ADD CONSTRAINT pk_doc_swrpac PRIMARY KEY (id_document, id_swrpac);


--
-- Name: doc_swrprover pk_doc_swrprover; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrprover
    ADD CONSTRAINT pk_doc_swrprover PRIMARY KEY (id_document, id_softwareproduct, version);


--
-- Name: doc_swrproverdeptyp pk_doc_swrproverdeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrproverdeptyp
    ADD CONSTRAINT pk_doc_swrproverdeptyp PRIMARY KEY (dependency);


--
-- Name: doc_worktyp pk_doc_worktyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_worktyp
    ADD CONSTRAINT pk_doc_worktyp PRIMARY KEY (id);


--
-- Name: docdep pk_docdep; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docdep
    ADD CONSTRAINT pk_docdep PRIMARY KEY (id_superdoc, id_subdoc);


--
-- Name: docdeptyp pk_docdeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docdeptyp
    ADD CONSTRAINT pk_docdeptyp PRIMARY KEY (dependency_forward);


--
-- Name: docown_work pk_docown_work; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docown_work
    ADD CONSTRAINT pk_docown_work PRIMARY KEY (id_document, id_owner, docno, pagerange, worktyp);


--
-- Name: doctyp pk_doctyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doctyp
    ADD CONSTRAINT pk_doctyp PRIMARY KEY (id);


--
-- Name: drawingcode pk_drawingcode; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.drawingcode
    ADD CONSTRAINT pk_drawingcode PRIMARY KEY (id_drawingcode);


--
-- Name: hwr pk_hwr; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr
    ADD CONSTRAINT pk_hwr PRIMARY KEY (id);


--
-- Name: hwr_busses pk_hwr_busses; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_busses
    ADD CONSTRAINT pk_hwr_busses PRIMARY KEY (id_hardware, id_bus);


--
-- Name: hwr_code pk_hwr_code; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_code
    ADD CONSTRAINT pk_hwr_code PRIMARY KEY (id_hwrcode);


--
-- Name: hwr_config pk_hwr_config; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_config
    ADD CONSTRAINT pk_hwr_config PRIMARY KEY (id_superhardware, supervariant, superserialno, id_subhardware, subvariant, subserialno, configno);


--
-- Name: hwr_hwrfunction pk_hwr_hwrfunction; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_hwrfunction
    ADD CONSTRAINT pk_hwr_hwrfunction PRIMARY KEY (hardware, function);


--
-- Name: hwr_tests pk_hwr_tests; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_tests
    ADD CONSTRAINT pk_hwr_tests PRIMARY KEY (id);


--
-- Name: hwr_worktyp pk_hwr_worktyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_worktyp
    ADD CONSTRAINT pk_hwr_worktyp PRIMARY KEY (id);


--
-- Name: hwrfunction pk_hwrfunction; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrfunction
    ADD CONSTRAINT pk_hwrfunction PRIMARY KEY (id);


--
-- Name: hwrtyp pk_hwrtyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrtyp
    ADD CONSTRAINT pk_hwrtyp PRIMARY KEY (id);


--
-- Name: hwrvar pk_hwrvar; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar
    ADD CONSTRAINT pk_hwrvar PRIMARY KEY (id_hardware, variant);


--
-- Name: hwrvar_owners pk_hwrvar_owners; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_owners
    ADD CONSTRAINT pk_hwrvar_owners PRIMARY KEY (id_hardware, variant, serialno);


--
-- Name: hwrvar_rev pk_hwrvar_rev; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_rev
    ADD CONSTRAINT pk_hwrvar_rev PRIMARY KEY (id_hardware, variant, revision, changeno);


--
-- Name: hwrvar_val pk_hwrvar_val; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_val
    ADD CONSTRAINT pk_hwrvar_val PRIMARY KEY (id_hardware, variant, id_valtyp, unit);


--
-- Name: hwrvardep pk_hwrvardep; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvardep
    ADD CONSTRAINT pk_hwrvardep PRIMARY KEY (id_superhardware, supervariant, id_subhardware, subvariant, dependency);


--
-- Name: hwrvardeptyp pk_hwrvardeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvardeptyp
    ADD CONSTRAINT pk_hwrvardeptyp PRIMARY KEY (dependency_forward);


--
-- Name: hwrvarown_tests pk_hwrvarown_tests; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvarown_tests
    ADD CONSTRAINT pk_hwrvarown_tests PRIMARY KEY (id_hardware, variant, serialno, test_date, test_no, id_test, test_subtype);


--
-- Name: kits pk_kits; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kits
    ADD CONSTRAINT pk_kits PRIMARY KEY (id);


--
-- Name: kitstyp pk_kitstyp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitstyp
    ADD CONSTRAINT pk_kitstyp PRIMARY KEY (id);


--
-- Name: kitsvar pk_kitsvar; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitsvar
    ADD CONSTRAINT pk_kitsvar PRIMARY KEY (id_kit, variant);


--
-- Name: languages pk_languages; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT pk_languages PRIMARY KEY (id);


--
-- Name: lic pk_lic; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic
    ADD CONSTRAINT pk_lic PRIMARY KEY (id_softwareproduct, id_softwarelicense, version, units, availability, activity, keyoptions);


--
-- Name: lic_input pk_lic_input; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic_input
    ADD CONSTRAINT pk_lic_input PRIMARY KEY (auth);


--
-- Name: lic_owners pk_lic_owners; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic_owners
    ADD CONSTRAINT pk_lic_owners PRIMARY KEY (id_owner, authno);


--
-- Name: licpro pk_licpro; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.licpro
    ADD CONSTRAINT pk_licpro PRIMARY KEY (id);


--
-- Name: licprovar pk_licprovar; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.licprovar
    ADD CONSTRAINT pk_licprovar PRIMARY KEY (id_licpro, variant);


--
-- Name: origins pk_origins; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.origins
    ADD CONSTRAINT pk_origins PRIMARY KEY (id);


--
-- Name: owners pk_owners; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT pk_owners PRIMARY KEY (id);


--
-- Name: papersizes pk_papersizes; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.papersizes
    ADD CONSTRAINT pk_papersizes PRIMARY KEY (id);


--
-- Name: pins pk_pins; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT pk_pins PRIMARY KEY (pin);


--
-- Name: plantcode pk_plantcode; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.plantcode
    ADD CONSTRAINT pk_plantcode PRIMARY KEY (id_plantcode, id_sid);


--
-- Name: storages pk_storages; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT pk_storages PRIMARY KEY (id, id_owner);


--
-- Name: swr_worktyp pk_swr_worktyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swr_worktyp
    ADD CONSTRAINT pk_swr_worktyp PRIMARY KEY (id);


--
-- Name: swrformat pk_swrformat; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrformat
    ADD CONSTRAINT pk_swrformat PRIMARY KEY (id);


--
-- Name: swrmedia pk_swrmedia; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrmedia
    ADD CONSTRAINT pk_swrmedia PRIMARY KEY (id);


--
-- Name: swrpac pk_swrpac; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac
    ADD CONSTRAINT pk_swrpac PRIMARY KEY (id);


--
-- Name: swrpac_owners pk_swrpac_owners; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_owners
    ADD CONSTRAINT pk_swrpac_owners PRIMARY KEY (id_swrpac, swrpacno, id_owner);


--
-- Name: swrpac_worktyp pk_swrpac_worktyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_worktyp
    ADD CONSTRAINT pk_swrpac_worktyp PRIMARY KEY (id);


--
-- Name: swrpacdep pk_swrpacdep; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpacdep
    ADD CONSTRAINT pk_swrpacdep PRIMARY KEY (id_supersoftwarepackage, id_subsoftwarepackage);


--
-- Name: swrpacdeptyp pk_swrpacdeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpacdeptyp
    ADD CONSTRAINT pk_swrpacdeptyp PRIMARY KEY (dependency_forward);


--
-- Name: swrpactyp pk_swrpactyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpactyp
    ADD CONSTRAINT pk_swrpactyp PRIMARY KEY (id);


--
-- Name: swrpro pk_swrpro; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro
    ADD CONSTRAINT pk_swrpro PRIMARY KEY (id);


--
-- Name: swrpro_swrlic pk_swrpro_swrlic; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro_swrlic
    ADD CONSTRAINT pk_swrpro_swrlic PRIMARY KEY (id_softwareproduct, id_softwarelicense);


--
-- Name: swrpro_upi pk_swrpro_upi; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro_upi
    ADD CONSTRAINT pk_swrpro_upi PRIMARY KEY (id_swrpro, upi);


--
-- Name: swrprotyp pk_swrprotyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprotyp
    ADD CONSTRAINT pk_swrprotyp PRIMARY KEY (id);


--
-- Name: swrprover pk_swrprover; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover
    ADD CONSTRAINT pk_swrprover PRIMARY KEY (id_softwareproduct, version);


--
-- Name: swrprover_hwrvar pk_swrprover_hwrvar; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_hwrvar
    ADD CONSTRAINT pk_swrprover_hwrvar PRIMARY KEY (id_hardware, variant, id_softwareproduct, version);


--
-- Name: swrprover_hwrvardeptyp pk_swrprover_hwrvardeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_hwrvardeptyp
    ADD CONSTRAINT pk_swrprover_hwrvardeptyp PRIMARY KEY (dependency_forward);


--
-- Name: swrprover_licprovar pk_swrprover_licprovar; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_licprovar
    ADD CONSTRAINT pk_swrprover_licprovar PRIMARY KEY (id_licpro, variant, id_softwareproduct, version);


--
-- Name: swrprover_licprovardeptyp pk_swrprover_licprovardeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_licprovardeptyp
    ADD CONSTRAINT pk_swrprover_licprovardeptyp PRIMARY KEY (dependency_forward);


--
-- Name: swrprover_swrpac pk_swrprover_swrpac; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_swrpac
    ADD CONSTRAINT pk_swrprover_swrpac PRIMARY KEY (id_softwareproduct, language, version, id_swrpac);


--
-- Name: swrprover_val pk_swrprover_val; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_val
    ADD CONSTRAINT pk_swrprover_val PRIMARY KEY (id_softwareproduct, version, id_valtyp, unit);


--
-- Name: swrproverdep pk_swrproverdep; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrproverdep
    ADD CONSTRAINT pk_swrproverdep PRIMARY KEY (id_superswrprover, superversion, id_subswrprover, subversion);


--
-- Name: swrproverdeptyp pk_swrproverdeptyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrproverdeptyp
    ADD CONSTRAINT pk_swrproverdeptyp PRIMARY KEY (dependency_forward);


--
-- Name: units pk_units; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT pk_units PRIMARY KEY (id);


--
-- Name: valtyp_unit pk_valtyp_unit; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.valtyp_unit
    ADD CONSTRAINT pk_valtyp_unit PRIMARY KEY (valtyp, unit);


--
-- Name: valtypes pk_valtypes; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.valtypes
    ADD CONSTRAINT pk_valtypes PRIMARY KEY (id);


--
-- Name: wires2 pk_wires2; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.wires2
    ADD CONSTRAINT pk_wires2 PRIMARY KEY (id_backp, id_wire, pin_from, pin_to);


--
-- Name: workstatustyp pk_workstatustyp; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.workstatustyp
    ADD CONSTRAINT pk_workstatustyp PRIMARY KEY (id);


--
-- Name: swrpro ui_spd; Type: CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro
    ADD CONSTRAINT ui_spd UNIQUE (spd);


--
-- Name: in_hwrvar_idhardware; Type: INDEX; Schema: public; Owner: ulli
--

CREATE INDEX in_hwrvar_idhardware ON public.hwrvar USING btree (id_hardware);


--
-- Name: INDEX in_hwrvar_idhardware; Type: COMMENT; Schema: public; Owner: ulli
--

COMMENT ON INDEX public.in_hwrvar_idhardware IS 'only for testing';


--
-- Name: in_kitsvar_idkit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX in_kitsvar_idkit ON public.kitsvar USING btree (id_kit);


--
-- Name: ui_upi; Type: INDEX; Schema: public; Owner: ulli
--

CREATE UNIQUE INDEX ui_upi ON public.swrpro USING btree (upi);


--
-- Name: ui_wires_1; Type: INDEX; Schema: public; Owner: ulli
--

CREATE UNIQUE INDEX ui_wires_1 ON public.wires2 USING btree (id_backp, pin_from, pin_to);


--
-- Name: ui_wires_2; Type: INDEX; Schema: public; Owner: ulli
--

CREATE UNIQUE INDEX ui_wires_2 ON public.wires2 USING btree (id_backp, id_wire);


--
-- Name: hwr_busses fk_busseshwr_busses; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_busses
    ADD CONSTRAINT fk_busseshwr_busses FOREIGN KEY (id_bus) REFERENCES public.busses(id) ON UPDATE CASCADE;


--
-- Name: hwr_busses fk_busseshwr_hwr; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_busses
    ADD CONSTRAINT fk_busseshwr_hwr FOREIGN KEY (id_hardware) REFERENCES public.hwr(id) ON UPDATE CASCADE;


--
-- Name: cddir fk_cddir_swrpac; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.cddir
    ADD CONSTRAINT fk_cddir_swrpac FOREIGN KEY (id_swrpac) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: doc fk_doc_doctyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc
    ADD CONSTRAINT fk_doc_doctyp FOREIGN KEY (doctype) REFERENCES public.doctyp(id) ON UPDATE CASCADE;


--
-- Name: doc fk_doc_languages; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc
    ADD CONSTRAINT fk_doc_languages FOREIGN KEY (language) REFERENCES public.languages(id) ON UPDATE CASCADE;


--
-- Name: doc fk_doc_origins; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc
    ADD CONSTRAINT fk_doc_origins FOREIGN KEY (origin) REFERENCES public.origins(id) ON UPDATE CASCADE;


--
-- Name: doc fk_doc_papersizes; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc
    ADD CONSTRAINT fk_doc_papersizes FOREIGN KEY (papersize) REFERENCES public.papersizes(id) ON UPDATE CASCADE;


--
-- Name: doc_authors fk_docauthors_authors; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_authors
    ADD CONSTRAINT fk_docauthors_authors FOREIGN KEY (id_author) REFERENCES public.authors(id) ON UPDATE CASCADE;


--
-- Name: doc_authors fk_docauthors_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_authors
    ADD CONSTRAINT fk_docauthors_doc FOREIGN KEY (id_document) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: docdep fk_docdep_docdeptyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docdep
    ADD CONSTRAINT fk_docdep_docdeptyp FOREIGN KEY (dependency) REFERENCES public.docdeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: docdep fk_docdep_sub; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docdep
    ADD CONSTRAINT fk_docdep_sub FOREIGN KEY (id_subdoc) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: docdep fk_docdep_super; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docdep
    ADD CONSTRAINT fk_docdep_super FOREIGN KEY (id_superdoc) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: doc_hwr fk_dochwr_dochwrdeptyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_hwr
    ADD CONSTRAINT fk_dochwr_dochwrdeptyp FOREIGN KEY (dependency) REFERENCES public.doc_hwrdeptyp(dependency) ON UPDATE CASCADE;


--
-- Name: doc_hwr fk_dochwr_documents; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_hwr
    ADD CONSTRAINT fk_dochwr_documents FOREIGN KEY (id_document) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: doc_hwr fk_dochwr_hwrvar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_hwr
    ADD CONSTRAINT fk_dochwr_hwrvar FOREIGN KEY (id_hardware, variant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: doc_owners fk_docowners_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_owners
    ADD CONSTRAINT fk_docowners_doc FOREIGN KEY (id_document) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: doc_owners fk_docowners_owners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_owners
    ADD CONSTRAINT fk_docowners_owners FOREIGN KEY (id_owner) REFERENCES public.owners(id) ON UPDATE CASCADE;


--
-- Name: doc_owners fk_docowners_storages; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_owners
    ADD CONSTRAINT fk_docowners_storages FOREIGN KEY (storage, id_owner) REFERENCES public.storages(id, id_owner) ON UPDATE CASCADE;


--
-- Name: docown_work fk_docownwork_docown; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docown_work
    ADD CONSTRAINT fk_docownwork_docown FOREIGN KEY (id_document, id_owner, docno) REFERENCES public.doc_owners(id_document, id_owner, docno) ON UPDATE CASCADE;


--
-- Name: docown_work fk_docownwork_workstatus; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docown_work
    ADD CONSTRAINT fk_docownwork_workstatus FOREIGN KEY (workstatus) REFERENCES public.workstatustyp(id) ON UPDATE CASCADE;


--
-- Name: docown_work fk_docownwork_worktype; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.docown_work
    ADD CONSTRAINT fk_docownwork_worktype FOREIGN KEY (worktyp) REFERENCES public.doc_worktyp(id) ON UPDATE CASCADE;


--
-- Name: doc_swrpac fk_docswrpac_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrpac
    ADD CONSTRAINT fk_docswrpac_doc FOREIGN KEY (id_document) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: doc_swrpac fk_docswrpac_swrpac; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrpac
    ADD CONSTRAINT fk_docswrpac_swrpac FOREIGN KEY (id_swrpac) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: doc_swrprover fk_docswrprover_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrprover
    ADD CONSTRAINT fk_docswrprover_doc FOREIGN KEY (id_document) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: doc_swrprover fk_docswrprover_docswrproverdeptyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrprover
    ADD CONSTRAINT fk_docswrprover_docswrproverdeptyp FOREIGN KEY (dependency) REFERENCES public.doc_swrproverdeptyp(dependency) ON UPDATE CASCADE;


--
-- Name: doc_swrprover fk_docswrprover_swrprover; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.doc_swrprover
    ADD CONSTRAINT fk_docswrprover_swrprover FOREIGN KEY (id_softwareproduct, version) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: hwr fk_hwr_hwrtyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr
    ADD CONSTRAINT fk_hwr_hwrtyp FOREIGN KEY (hierarchylevel) REFERENCES public.hwrtyp(id) ON UPDATE CASCADE;


--
-- Name: hwr fk_hwr_origins; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr
    ADD CONSTRAINT fk_hwr_origins FOREIGN KEY (origin) REFERENCES public.origins(id) ON UPDATE CASCADE;


--
-- Name: hwr_config fk_hwrconfig_subhwrvarowners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_config
    ADD CONSTRAINT fk_hwrconfig_subhwrvarowners FOREIGN KEY (id_subhardware, subvariant, subserialno) REFERENCES public.hwrvar_owners(id_hardware, variant, serialno) ON UPDATE CASCADE;


--
-- Name: hwr_config fk_hwrconfig_superhwrvarowners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_config
    ADD CONSTRAINT fk_hwrconfig_superhwrvarowners FOREIGN KEY (id_superhardware, supervariant, superserialno) REFERENCES public.hwrvar_owners(id_hardware, variant, serialno) ON UPDATE CASCADE;


--
-- Name: hwr_hwrfunction fk_hwrhwrfunction_hwr; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_hwrfunction
    ADD CONSTRAINT fk_hwrhwrfunction_hwr FOREIGN KEY (hardware) REFERENCES public.hwr(id) ON UPDATE CASCADE;


--
-- Name: hwr_hwrfunction fk_hwrhwrfunction_hwrfunction; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwr_hwrfunction
    ADD CONSTRAINT fk_hwrhwrfunction_hwrfunction FOREIGN KEY (function) REFERENCES public.hwrfunction(id) ON UPDATE CASCADE;


--
-- Name: hwrown_work fk_hwrownwork_hwrown; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrown_work
    ADD CONSTRAINT fk_hwrownwork_hwrown FOREIGN KEY (id_hwr, id_variant, serialno) REFERENCES public.hwrvar_owners(id_hardware, variant, serialno) ON UPDATE CASCADE;


--
-- Name: hwrown_work fk_hwrownwork_workstatus; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrown_work
    ADD CONSTRAINT fk_hwrownwork_workstatus FOREIGN KEY (workstatus) REFERENCES public.workstatustyp(id) ON UPDATE CASCADE;


--
-- Name: hwrown_work fk_hwrownwork_worktype; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrown_work
    ADD CONSTRAINT fk_hwrownwork_worktype FOREIGN KEY (worktyp) REFERENCES public.hwr_worktyp(id) ON UPDATE CASCADE;


--
-- Name: hwrvar fk_hwrvar_hwr; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar
    ADD CONSTRAINT fk_hwrvar_hwr FOREIGN KEY (id_hardware) REFERENCES public.hwr(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hwrvardep fk_hwrvardep_dependency; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvardep
    ADD CONSTRAINT fk_hwrvardep_dependency FOREIGN KEY (dependency) REFERENCES public.hwrvardeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: hwrvardep fk_hwrvardep_sub; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvardep
    ADD CONSTRAINT fk_hwrvardep_sub FOREIGN KEY (id_subhardware, subvariant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: hwrvardep fk_hwrvardep_super; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvardep
    ADD CONSTRAINT fk_hwrvardep_super FOREIGN KEY (id_superhardware, supervariant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: hwrvar_owners fk_hwrvarowners_hwrvar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_owners
    ADD CONSTRAINT fk_hwrvarowners_hwrvar FOREIGN KEY (id_hardware, variant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: hwrvar_owners fk_hwrvarowners_owners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_owners
    ADD CONSTRAINT fk_hwrvarowners_owners FOREIGN KEY (id_owner) REFERENCES public.owners(id) ON UPDATE CASCADE;


--
-- Name: hwrvar_owners fk_hwrvarowners_storages; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_owners
    ADD CONSTRAINT fk_hwrvarowners_storages FOREIGN KEY (storage, id_owner) REFERENCES public.storages(id, id_owner) ON UPDATE CASCADE;


--
-- Name: hwrvarown_tests fk_hwrvarowntests_hwrvarown; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvarown_tests
    ADD CONSTRAINT fk_hwrvarowntests_hwrvarown FOREIGN KEY (id_hardware, variant, serialno) REFERENCES public.hwrvar_owners(id_hardware, variant, serialno) ON UPDATE CASCADE;


--
-- Name: hwrvarown_tests fk_hwrvarowntests_tests; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvarown_tests
    ADD CONSTRAINT fk_hwrvarowntests_tests FOREIGN KEY (id_test) REFERENCES public.hwr_tests(id) ON UPDATE CASCADE;


--
-- Name: hwrvar_rev fk_hwrvarrev_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_rev
    ADD CONSTRAINT fk_hwrvarrev_doc FOREIGN KEY (docref) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: hwrvar_rev fk_hwrvarrev_hwrvar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_rev
    ADD CONSTRAINT fk_hwrvarrev_hwrvar FOREIGN KEY (id_hardware, variant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: hwrvar_val fk_hwrvarval_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_val
    ADD CONSTRAINT fk_hwrvarval_doc FOREIGN KEY (docref) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: hwrvar_val fk_hwrvarval_hwrvar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_val
    ADD CONSTRAINT fk_hwrvarval_hwrvar FOREIGN KEY (id_hardware, variant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: hwrvar_val fk_hwrvarval_valtypunit; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.hwrvar_val
    ADD CONSTRAINT fk_hwrvarval_valtypunit FOREIGN KEY (id_valtyp, unit) REFERENCES public.valtyp_unit(valtyp, unit) ON UPDATE CASCADE;


--
-- Name: kitsvar fk_kits_kitsvar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitsvar
    ADD CONSTRAINT fk_kits_kitsvar FOREIGN KEY (id_kit) REFERENCES public.kits(id) ON UPDATE CASCADE;


--
-- Name: kitsvar fk_kitstyp_kitsvar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kitsvar
    ADD CONSTRAINT fk_kitstyp_kitsvar FOREIGN KEY (variant) REFERENCES public.kitstyp(id) ON UPDATE CASCADE;


--
-- Name: lic fk_lic_swrproswrlic; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic
    ADD CONSTRAINT fk_lic_swrproswrlic FOREIGN KEY (id_softwareproduct, id_softwarelicense) REFERENCES public.swrpro_swrlic(id_softwareproduct, id_softwarelicense) ON UPDATE CASCADE;


--
-- Name: lic_owners fk_licowners_lic; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic_owners
    ADD CONSTRAINT fk_licowners_lic FOREIGN KEY (id_softwareproduct, id_softwarelicense, version, units, availability, activity, keyoptions) REFERENCES public.lic(id_softwareproduct, id_softwarelicense, version, units, availability, activity, keyoptions) ON UPDATE CASCADE;


--
-- Name: lic_owners fk_licowners_owners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.lic_owners
    ADD CONSTRAINT fk_licowners_owners FOREIGN KEY (id_owner) REFERENCES public.owners(id) ON UPDATE CASCADE;


--
-- Name: licprovar fk_licprovar_licpro; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.licprovar
    ADD CONSTRAINT fk_licprovar_licpro FOREIGN KEY (id_licpro) REFERENCES public.licpro(id) ON UPDATE CASCADE;


--
-- Name: origins fk_origins_countries; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.origins
    ADD CONSTRAINT fk_origins_countries FOREIGN KEY (country) REFERENCES public.countries(id) ON UPDATE CASCADE;


--
-- Name: storages fk_storages_owners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT fk_storages_owners FOREIGN KEY (id_owner) REFERENCES public.owners(id) ON UPDATE CASCADE;


--
-- Name: swrpac fk_swrpac_swrformat; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac
    ADD CONSTRAINT fk_swrpac_swrformat FOREIGN KEY (softwareformat) REFERENCES public.swrformat(id) ON UPDATE CASCADE;


--
-- Name: swrpac fk_swrpac_swrmedia; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac
    ADD CONSTRAINT fk_swrpac_swrmedia FOREIGN KEY (softwaremedium) REFERENCES public.swrmedia(id) ON UPDATE CASCADE;


--
-- Name: swrpac fk_swrpac_swrpactyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac
    ADD CONSTRAINT fk_swrpac_swrpactyp FOREIGN KEY (softwarepackagetype) REFERENCES public.swrpactyp(id) ON UPDATE CASCADE;


--
-- Name: swrpacdep fk_swrpacdep_subsoftwarepackage; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpacdep
    ADD CONSTRAINT fk_swrpacdep_subsoftwarepackage FOREIGN KEY (id_subsoftwarepackage) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: swrpacdep fk_swrpacdep_supersoftwarepackage; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpacdep
    ADD CONSTRAINT fk_swrpacdep_supersoftwarepackage FOREIGN KEY (id_supersoftwarepackage) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: swrpacdep fk_swrpacdep_swrpacdeptyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpacdep
    ADD CONSTRAINT fk_swrpacdep_swrpacdeptyp FOREIGN KEY (dependency) REFERENCES public.swrpacdeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: swrpac_owners fk_swrpacowners_owners; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_owners
    ADD CONSTRAINT fk_swrpacowners_owners FOREIGN KEY (id_owner) REFERENCES public.owners(id) ON UPDATE CASCADE;


--
-- Name: swrpac_owners fk_swrpacowners_storages; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_owners
    ADD CONSTRAINT fk_swrpacowners_storages FOREIGN KEY (storage, id_owner) REFERENCES public.storages(id, id_owner) ON UPDATE CASCADE;


--
-- Name: swrpac_owners fk_swrpacowners_swrmedia; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_owners
    ADD CONSTRAINT fk_swrpacowners_swrmedia FOREIGN KEY (softwaremedium) REFERENCES public.swrmedia(id) ON UPDATE CASCADE;


--
-- Name: swrpac_owners fk_swrpacowners_swrpac; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpac_owners
    ADD CONSTRAINT fk_swrpacowners_swrpac FOREIGN KEY (id_swrpac) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: swrpro fk_swrpro_diaglevels; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro
    ADD CONSTRAINT fk_swrpro_diaglevels FOREIGN KEY (diaglevel) REFERENCES public.diaglevels(id) ON UPDATE CASCADE;


--
-- Name: swrpro fk_swrpro_origins; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro
    ADD CONSTRAINT fk_swrpro_origins FOREIGN KEY (origin) REFERENCES public.origins(id) ON UPDATE CASCADE;


--
-- Name: swrpro fk_swrpro_swrprotyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro
    ADD CONSTRAINT fk_swrpro_swrprotyp FOREIGN KEY (type) REFERENCES public.swrprotyp(id) ON UPDATE CASCADE;


--
-- Name: swrpro_upi fk_swrpro_upi_swrpro; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro_upi
    ADD CONSTRAINT fk_swrpro_upi_swrpro FOREIGN KEY (id_swrpro) REFERENCES public.swrpro(id) ON UPDATE CASCADE;


--
-- Name: swrpro_swrlic fk_swrproswrlic_swrpro; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrpro_swrlic
    ADD CONSTRAINT fk_swrproswrlic_swrpro FOREIGN KEY (id_softwareproduct) REFERENCES public.swrpro(id) ON UPDATE CASCADE;


--
-- Name: swrprover_hwrvar fk_swrprover_dependency; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_hwrvar
    ADD CONSTRAINT fk_swrprover_dependency FOREIGN KEY (dependency) REFERENCES public.swrprover_hwrvardeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: swrprover_licprovar fk_swrprover_dependency; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_licprovar
    ADD CONSTRAINT fk_swrprover_dependency FOREIGN KEY (dependency) REFERENCES public.swrprover_licprovardeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: swrprover_hwrvar fk_swrprover_hwrvar_hwrvar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_hwrvar
    ADD CONSTRAINT fk_swrprover_hwrvar_hwrvar FOREIGN KEY (id_hardware, variant) REFERENCES public.hwrvar(id_hardware, variant) ON UPDATE CASCADE;


--
-- Name: swrprover_hwrvar fk_swrprover_hwrvar_swrprover; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_hwrvar
    ADD CONSTRAINT fk_swrprover_hwrvar_swrprover FOREIGN KEY (id_softwareproduct, version) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrprover_licprovar fk_swrprover_hwrvar_swrprover; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_licprovar
    ADD CONSTRAINT fk_swrprover_hwrvar_swrprover FOREIGN KEY (id_softwareproduct, version) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrprover_licprovar fk_swrprover_licprovar_licprovar; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_licprovar
    ADD CONSTRAINT fk_swrprover_licprovar_licprovar FOREIGN KEY (id_licpro, variant) REFERENCES public.licprovar(id_licpro, variant) ON UPDATE CASCADE;


--
-- Name: swrprover fk_swrprover_swrpro; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover
    ADD CONSTRAINT fk_swrprover_swrpro FOREIGN KEY (id_softwareproduct) REFERENCES public.swrpro(id) ON UPDATE CASCADE;


--
-- Name: swrproverdep fk_swrproverdep_sub; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrproverdep
    ADD CONSTRAINT fk_swrproverdep_sub FOREIGN KEY (id_subswrprover, subversion) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrproverdep fk_swrproverdep_super; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrproverdep
    ADD CONSTRAINT fk_swrproverdep_super FOREIGN KEY (id_superswrprover, superversion) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrproverdep fk_swrproverdep_swrproverdeptyp; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrproverdep
    ADD CONSTRAINT fk_swrproverdep_swrproverdeptyp FOREIGN KEY (dependency) REFERENCES public.swrproverdeptyp(dependency_forward) ON UPDATE CASCADE;


--
-- Name: swrprover_swrpac fk_swrproverswrpac_swrpac; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_swrpac
    ADD CONSTRAINT fk_swrproverswrpac_swrpac FOREIGN KEY (id_swrpac) REFERENCES public.swrpac(id) ON UPDATE CASCADE;


--
-- Name: swrprover_swrpac fk_swrproverswrpac_swrprover; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_swrpac
    ADD CONSTRAINT fk_swrproverswrpac_swrprover FOREIGN KEY (id_softwareproduct, version) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrprover_val fk_swrproverval_doc; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_val
    ADD CONSTRAINT fk_swrproverval_doc FOREIGN KEY (docref) REFERENCES public.doc(id) ON UPDATE CASCADE;


--
-- Name: swrprover_val fk_swrproverval_swrprover; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_val
    ADD CONSTRAINT fk_swrproverval_swrprover FOREIGN KEY (id_softwareproduct, version) REFERENCES public.swrprover(id_softwareproduct, version) ON UPDATE CASCADE;


--
-- Name: swrprover_val fk_swrproverval_valtypunit; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.swrprover_val
    ADD CONSTRAINT fk_swrproverval_valtypunit FOREIGN KEY (id_valtyp, unit) REFERENCES public.valtyp_unit(valtyp, unit) ON UPDATE CASCADE;


--
-- Name: valtyp_unit fk_valtyp_units; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.valtyp_unit
    ADD CONSTRAINT fk_valtyp_units FOREIGN KEY (unit) REFERENCES public.units(id) ON UPDATE CASCADE;


--
-- Name: valtyp_unit fk_valtypunit_units; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.valtyp_unit
    ADD CONSTRAINT fk_valtypunit_units FOREIGN KEY (unit) REFERENCES public.units(id) ON UPDATE CASCADE;


--
-- Name: valtyp_unit fk_valtypunit_valtypes; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.valtyp_unit
    ADD CONSTRAINT fk_valtypunit_valtypes FOREIGN KEY (valtyp) REFERENCES public.valtypes(id) ON UPDATE CASCADE;


--
-- Name: wires2 fk_wiresfrom_pins; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.wires2
    ADD CONSTRAINT fk_wiresfrom_pins FOREIGN KEY (pin_from) REFERENCES public.pins(pin);


--
-- Name: wires2 fk_wiresto_pins; Type: FK CONSTRAINT; Schema: public; Owner: ulli
--

ALTER TABLE ONLY public.wires2
    ADD CONSTRAINT fk_wiresto_pins FOREIGN KEY (pin_to) REFERENCES public.pins(pin);


--
-- Name: TABLE authors; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.authors TO decor_users;


--
-- Name: TABLE busses; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.busses TO decor_users;


--
-- Name: TABLE hwr; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr TO decor_users;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.countries TO decor_users;


--
-- Name: TABLE import; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.import TO decor_users;


--
-- Name: TABLE d_import; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.d_import TO decor_users;


--
-- Name: TABLE decdoc_versions; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.decdoc_versions TO decor_users;


--
-- Name: TABLE diag_import; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.diag_import TO decor_users;


--
-- Name: TABLE diaglevels; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.diaglevels TO decor_users;


--
-- Name: TABLE doc; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc TO decor_users;


--
-- Name: TABLE doc_authors; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_authors TO decor_users;


--
-- Name: TABLE doc_hwr; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_hwr TO decor_users;


--
-- Name: TABLE doc_hwrdeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_hwrdeptyp TO decor_users;


--
-- Name: TABLE doc_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_owners TO decor_users;


--
-- Name: TABLE doc_swrpac; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_swrpac TO decor_users;


--
-- Name: TABLE doc_swrprover; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_swrprover TO decor_users;


--
-- Name: TABLE doc_swrproverdeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_swrproverdeptyp TO decor_users;


--
-- Name: TABLE doc_worktyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doc_worktyp TO decor_users;


--
-- Name: TABLE docdep; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.docdep TO decor_users;


--
-- Name: TABLE docdeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.docdeptyp TO decor_users;


--
-- Name: TABLE docown_work; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.docown_work TO decor_users;


--
-- Name: TABLE doctyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.doctyp TO decor_users;


--
-- Name: TABLE drawingcode; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.drawingcode TO decor_users;


--
-- Name: TABLE hwr_busses; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_busses TO decor_users;


--
-- Name: TABLE hwr_code; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_code TO decor_users;


--
-- Name: TABLE hwr_config; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_config TO decor_users;


--
-- Name: TABLE hwr_hwrfunction; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_hwrfunction TO decor_users;


--
-- Name: TABLE hwr_noitem; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_noitem TO decor_users;


--
-- Name: TABLE hwr_tests; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_tests TO decor_users;


--
-- Name: TABLE hwr_worktyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwr_worktyp TO decor_users;


--
-- Name: TABLE hwrfunction; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrfunction TO decor_users;


--
-- Name: TABLE hwrown_work; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrown_work TO decor_users;


--
-- Name: TABLE hwrtyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrtyp TO decor_users;


--
-- Name: TABLE hwrvar; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvar TO decor_users;


--
-- Name: TABLE hwrvar_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvar_owners TO decor_users;


--
-- Name: TABLE hwrvar_rev; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvar_rev TO decor_users;


--
-- Name: TABLE hwrvar_val; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvar_val TO decor_users;


--
-- Name: TABLE hwrvardep; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvardep TO decor_users;


--
-- Name: TABLE hwrvardeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvardeptyp TO decor_users;


--
-- Name: TABLE hwrvarown_tests; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.hwrvarown_tests TO decor_users;


--
-- Name: TABLE kits; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.kits TO decor_users;


--
-- Name: TABLE kitstyp; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.kitstyp TO decor_users;


--
-- Name: TABLE kitsvar; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.kitsvar TO decor_users;


--
-- Name: TABLE languages; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.languages TO decor_users;


--
-- Name: TABLE lic; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.lic TO decor_users;


--
-- Name: TABLE lic_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.lic_owners TO decor_users;


--
-- Name: TABLE newhwr; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.newhwr TO decor_users;


--
-- Name: TABLE nullnull; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.nullnull TO decor_users;


--
-- Name: TABLE novariant; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.novariant TO decor_users;


--
-- Name: TABLE origins; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.origins TO decor_users;


--
-- Name: TABLE owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.owners TO decor_users;


--
-- Name: TABLE papersizes; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.papersizes TO decor_users;


--
-- Name: TABLE plantcode; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.plantcode TO decor_users;


--
-- Name: TABLE storages; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.storages TO decor_users;


--
-- Name: TABLE summe_datensatz; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.summe_datensatz TO decor_users;


--
-- Name: TABLE swr_worktyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swr_worktyp TO decor_users;


--
-- Name: TABLE swrformat; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrformat TO decor_users;


--
-- Name: TABLE swrmedia; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrmedia TO decor_users;


--
-- Name: TABLE swrpac; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpac TO decor_users;


--
-- Name: TABLE swrpac_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpac_owners TO decor_users;


--
-- Name: TABLE swrpac_worktyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpac_worktyp TO decor_users;


--
-- Name: TABLE swrpacdep; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpacdep TO decor_users;


--
-- Name: TABLE swrpacdeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpacdeptyp TO decor_users;


--
-- Name: TABLE swrpactyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpactyp TO decor_users;


--
-- Name: TABLE swrpro; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpro TO decor_users;


--
-- Name: TABLE swrpro_swrlic; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrpro_swrlic TO decor_users;


--
-- Name: TABLE swrprotyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprotyp TO decor_users;


--
-- Name: TABLE swrprover; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprover TO decor_users;


--
-- Name: TABLE swrprover_hwrvar; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprover_hwrvar TO decor_users;


--
-- Name: TABLE swrprover_hwrvardeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprover_hwrvardeptyp TO decor_users;


--
-- Name: TABLE swrprover_swrpac; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprover_swrpac TO decor_users;


--
-- Name: TABLE swrprover_val; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrprover_val TO decor_users;


--
-- Name: TABLE swrproverdep; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrproverdep TO decor_users;


--
-- Name: TABLE swrproverdeptyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.swrproverdeptyp TO decor_users;


--
-- Name: TABLE units; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.units TO decor_users;


--
-- Name: TABLE valtyp_unit; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.valtyp_unit TO decor_users;


--
-- Name: TABLE valtypes; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.valtypes TO decor_users;


--
-- Name: TABLE vr_hwrvar_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.vr_hwrvar_owners TO decor_users;


--
-- Name: TABLE vr_modules; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.vr_modules TO decor_users;


--
-- Name: TABLE vr_swrproverswrpac_owners; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.vr_swrproverswrpac_owners TO decor_users;


--
-- Name: TABLE workstatustyp; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.workstatustyp TO decor_users;


--
-- Name: TABLE zahl_datensatz; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.zahl_datensatz TO decor_users;


--
-- Name: TABLE zahl_tabellen; Type: ACL; Schema: public; Owner: ulli
--

GRANT SELECT ON TABLE public.zahl_tabellen TO decor_users;


--
-- PostgreSQL database dump complete
--

