
CREATE EXTENSION IF NOT EXISTS cube;
CREATE EXTENSION IF NOT EXISTS earthdistance;	
CREATE EXTENSION IF NOT EXISTS postgis
--SELECT * FROM pg_available_extensions WHERE name IN ('cube', 'earthdistance');
--
--SELECT ll_to_earth(10.762622, 106.660172);
--
--DROP SCHEMA public CASCADE;
--CREATE SCHEMA public;
--GRANT ALL ON SCHEMA public TO postgres;
--GRANT ALL ON SCHEMA public TO public;

--SELECT current_database();


-- Định nghĩa các kiểu enum
CREATE TYPE "method_type" AS ENUM (
  'credit_card',
  'debit_card',
  'momo',
  'vnpay',
  'bank_transfer'
);

CREATE TYPE "payment_status" AS ENUM (
  'pending',
  'completed',
  'failed',
  'refunded',
  'partial_refund'
);

CREATE TYPE "verification_type" AS ENUM (
  'email',
  'phone'
);

CREATE TYPE "user_type" AS ENUM (
  'customer',
  'admin'
);

CREATE TYPE "availability_status" AS ENUM (
  'available',
  'busy',
  'offline'
);

CREATE TYPE "booking_status" AS ENUM (
  'pending',
  'assigned',
  'in_progress',
  'completed',
  'cancelled',
  'rescheduled'
);

CREATE TYPE "cancelled_by_type" AS ENUM (
  'user',
  'tasker',
  'admin'
);

CREATE TYPE "changed_by_type" AS ENUM (
  'user',
  'tasker',
  'admin',
  'system'
);

CREATE TYPE "earning_status" AS ENUM (
  'pending',
  'paid',
  'cancelled'
);

CREATE TYPE "payout_status" AS ENUM (
  'pending',
  'processed',
  'failed'
);

CREATE TYPE "reviewer_type" AS ENUM (
  'user',
  'tasker'
);

CREATE TYPE "sender_type" AS ENUM (
  'user',
  'tasker',
  'system'
);

CREATE TYPE "recipient_type" AS ENUM (
  'user',
  'tasker',
  'admin'
);

CREATE TYPE "price_unit_type" AS ENUM (
  'fixed',
  'hourly'
);

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "email" varchar(255) NOT NULL,
  "phone_number" varchar(15) NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "first_last_name" VARCHAR(100) NOT NULL,
  "profile_image" VARCHAR(255),
  "address" TEXT,
  "user_type" user_type NOT null,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "last_login" TIMESTAMP,
  "is_verified" BOOLEAN DEFAULT false,
  "is_active" BOOLEAN DEFAULT true,
   UNIQUE(email, phone_number)
);

CREATE TABLE "tasker" (
  "id" SERIAL PRIMARY KEY,
  "email" varchar(255) NOT NULL,
  "phone_number" varchar(15) NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "first_last_name" VARCHAR(100) NOT NULL,
  "profile_image" VARCHAR(255),
  "address" TEXT,
   "earth_location" geometry(Point, 4326),
  "latitude" DECIMAL(10,8),
  "longitude" DECIMAL(11,8),
  "average_rating" DECIMAL(3,2) DEFAULT 0,
  "total_earnings" DECIMAL(10,2) DEFAULT 0,
  "availability_status" availability_status NOT null,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "last_login" TIMESTAMP,
  "is_verified" BOOLEAN DEFAULT false,
  "is_active" BOOLEAN DEFAULT true,
  
  UNIQUE(email, phone_number)
);

--ALTER TABLE tasker 
--ALTER COLUMN earth_location TYPE geometry(Point, 4326) 
--USING ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);


CREATE TABLE "user_verifications" (
  "id" SERIAL PRIMARY KEY,
  "user_id" integer,
  "tasker_id" integer,
  "verification_code" VARCHAR(10) NOT NULL,
  "verification_type" verification_type NOT NULL,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "expires_at" TIMESTAMP(6) NOT NULL,
  "is_used" BOOLEAN DEFAULT false,
  CONSTRAINT "user_or_tasker_check" CHECK ((user_id IS NULL AND tasker_id IS NOT NULL) OR (user_id IS NOT NULL AND tasker_id IS NULL))
);

CREATE TABLE "favorite_tasker" (
  "id" serial PRIMARY KEY,
  "user_id" integer NOT NULL,
  "tasker_id" integer NOT NULL,
  "service_id" integer NOT NULL,
  UNIQUE(user_id, tasker_id, service_id)
);

CREATE TABLE "service_categories" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "icon" VARCHAR(255),
  "is_active" BOOLEAN DEFAULT true
);


alter table service_categories
drop column icon,
drop column description;

alter table services 
drop column price_unit,
drop column estimated_duration,
drop column icon;

CREATE TABLE "services" (
  "id" SERIAL PRIMARY KEY,
  "category_id" INTEGER NOT NULL,
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "base_price" DECIMAL(10,2) NOT NULL,
  "price_unit" price_unit_type NOT NULL,
  "estimated_duration" INTEGER NOT NULL,
  "icon" VARCHAR(255),
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "is_active" BOOLEAN DEFAULT true
);

CREATE TABLE "tasker_services" (
  "id" SERIAL PRIMARY KEY,
  "tasker_id" INTEGER NOT NULL,
  "service_id" INTEGER NOT NULL,
  "price_adjustment" DECIMAL(5,2) DEFAULT 0,
  "experience_years" DECIMAL(3,1) DEFAULT 0,
  "is_verified" BOOLEAN DEFAULT false,
  UNIQUE(tasker_id, service_id)
);

alter table tasker_services
drop column price_adjustment

CREATE TABLE "user_addresses" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "address_name" VARCHAR(100) NOT NULL,
  "address_line1" TEXT NOT NULL,
  "city" VARCHAR(100) NOT NULL,
  "country" VARCHAR(100) NOT NULL,
  "latitude" DECIMAL(10,8),
  "longitude" DECIMAL(11,8),
  "is_default" BOOLEAN DEFAULT false,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL
);

ALTER TABLE user_addresses
DROP COLUMN address_line1,
DROP COLUMN country,
DROP COLUMN city;


ALTER TABLE user_addresses
ADD COLUMN apartment_type VARCHAR(100),
add column houser_number varchar(100),
alter column address_name type varchar(255)

CREATE TABLE "bookings" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "tasker_id" INTEGER NOT NULL, --change not null -> null
  "service_id" INTEGER NOT NULL, 
  "address_id" INTEGER NOT NULL,-- change type data to text
  "scheduled_date" DATE NOT NULL,-- change data type to text
  "scheduled_time" TIME NOT NULL,-- remove column "scheduled_time"
  "duration" INTEGER NOT NULL, -- change data type to text
  "status" booking_status NOT NULL,
  "notes" text,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "completed_at" TIMESTAMP, -- drop this column
  "cancellation_reason" TEXT,
  "cancelled_by" cancelled_by_type,
  "is_recurring" BOOLEAN DEFAULT false,
  "recurring_pattern" VARCHAR(50) -- e.g., "weekly", "biweekly", "monthly"
);

alter table bookings
--drop constraint bookings_address_id_fkey
drop column scheduled_time,
drop column completed_at,
alter column tasker_id drop not null,
alter column address_id type TEXT,
alter column scheduled_date type text,
alter column duration type text,
add column work_load text

alter table bookings
RENAME column address_id to address_name

alter table bookings
add column house_numer text
add column total_price DECIMAL(5,2)


CREATE TABLE "booking_status_history" (
  "id" SERIAL PRIMARY KEY,
  "booking_id" INTEGER NOT NULL,
  "status" booking_status NOT NULL,
  "changed_by" changed_by_type NOT NULL,
  "changed_by_id" INTEGER NOT NULL,
  "changed_at" timestamp(6) DEFAULT now() NULL,
  "notes" TEXT
);

CREATE TABLE "payment_methods" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "method_type" method_type NOT NULL,
  "provider_name" VARCHAR(100),
  "account_number" VARCHAR(255),
  "expiry_date" VARCHAR(10),
  "is_default" BOOLEAN DEFAULT false,
  "is_active" BOOLEAN DEFAULT true,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL
);

CREATE TABLE "payments" (
  "id" SERIAL PRIMARY KEY,
  "booking_id" INTEGER NOT NULL,
  "user_id" INTEGER NOT NULL,
  "tasker_id" INTEGER NOT NULL,
  "payment_method_id" INTEGER NOT NULL,
  "amount" DECIMAL(10,2) NOT NULL,
  "currency" VARCHAR(3) DEFAULT 'VND',
  "status" payment_status NOT NULL,
  "transaction_id" VARCHAR(255),
  "payment_date" TIMESTAMP,
  "refund_amount" DECIMAL(10,2) DEFAULT 0,
  "refund_reason" TEXT,
  "refund_date" TIMESTAMP,
  "payment_gateway" VARCHAR(50) NOT NULL,
  "gateway_response" TEXT,
  "receipt_url" VARCHAR(255)
);

CREATE TABLE "tasker_earnings" (
  "id" SERIAL PRIMARY KEY,
  "tasker_id" INTEGER NOT NULL,
  "booking_id" INTEGER NOT NULL,
  "amount" DECIMAL(10,2) NOT NULL,
  "platform_fee" DECIMAL(10,2) NOT NULL,
  "net_amount" DECIMAL(10,2) NOT NULL,
  "status" earning_status NOT NULL,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "paid_at" TIMESTAMP
);

CREATE TABLE "tasker_payouts" (
  "id" SERIAL PRIMARY KEY,
  "tasker_id" INTEGER NOT NULL,
  "amount" DECIMAL(10,2) NOT NULL,
  "payout_method" VARCHAR(50) NOT NULL,
  "account_details" TEXT NOT NULL,
  "status" payout_status NOT NULL,
  "transaction_id" VARCHAR(255),
  "request_date" timestamp(6) DEFAULT now() NULL,
  "process_date" TIMESTAMP,
  "notes" TEXT
);

CREATE TABLE "reviews" (
  "id" SERIAL PRIMARY KEY,
  "booking_id" INTEGER NOT NULL,
  "reviewer_id" INTEGER NOT NULL,
  "reviewer_type" reviewer_type NOT NULL,
  "rating" INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  "comment" TEXT,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "is_public" BOOLEAN DEFAULT true
);

CREATE TABLE "chat_rooms" (
  "id" SERIAL PRIMARY KEY,
  "booking_id" INTEGER,
  "user_id" INTEGER NOT NULL,
  "tasker_id" INTEGER NOT NULL,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "last_message_at" timestamp(6) DEFAULT now() NULL,
  UNIQUE(user_id, tasker_id, booking_id)
);

CREATE TABLE "chat_messages" (
  "id" SERIAL PRIMARY KEY,
  "room_id" INTEGER NOT NULL,
  "sender_type" sender_type NOT NULL,
  "sender_id" INTEGER NOT NULL,
  "message_text" TEXT NOT NULL,
  "sent_at" timestamp(6) DEFAULT now() NULL,
  "is_read" BOOLEAN DEFAULT false,
  "read_at" TIMESTAMP
);

CREATE TABLE "user_preferences" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "service_category_id" INTEGER NOT NULL,
  "preference_level" INTEGER NOT NULL CHECK (preference_level >= 1 AND preference_level <= 5),
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  UNIQUE(user_id, service_category_id)
);

CREATE TABLE "tasker_unavailable_dates" (
  "id" SERIAL PRIMARY KEY,
  "tasker_id" INTEGER NOT NULL,
  "start_date" DATE NOT NULL,
  "end_date" DATE NOT NULL,
  "reason" VARCHAR(255)
);

CREATE TABLE "system_settings" (
  "id" SERIAL PRIMARY KEY,
  "setting_key" VARCHAR(100) NOT NULL,
  "setting_value" TEXT NOT NULL,
  "setting_description" TEXT,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  "updated_by" INTEGER,
  UNIQUE(setting_key)
);

CREATE TABLE "roles" (
  "id" SERIAL PRIMARY KEY,
  "role_name" VARCHAR(50) NOT NULL,
  "description" TEXT,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "updated_at" timestamp(6) DEFAULT now() NULL,
  UNIQUE(role_name)
);

CREATE TABLE "permissions" (
  "id" SERIAL PRIMARY KEY,
  "permission_name" VARCHAR(100) NOT NULL,
  "description" text,
  "created_at" timestamp(6) DEFAULT now() NULL,
  UNIQUE(permission_name)
);

CREATE TABLE "role_permissions" (
  "role_id" INTEGER,
  "permission_id" INTEGER,
  PRIMARY KEY(role_id, permission_id)
);

CREATE TABLE "user_roles" (
  "user_id" INTEGER,
  "role_id" INTEGER,
  "assigned_at" timestamp(6) DEFAULT now() NULL,
  "assigned_by" INTEGER,
  PRIMARY KEY(user_id, role_id)
);

CREATE TABLE "tasker_roles" (
  "tasker_id" INTEGER,
  "role_id" INTEGER,
  "assigned_at" timestamp(6) DEFAULT now() NULL,
  "assigned_by" INTEGER,
  PRIMARY KEY(tasker_id, role_id)
);

CREATE TABLE "notifications" (
  "id" SERIAL PRIMARY KEY,
  "recipient_type" recipient_type NOT NULL,
  "recipient_id" INTEGER NOT NULL,
  "title" VARCHAR(255) NOT NULL,
  "message" TEXT NOT NULL,
  "notification_type" VARCHAR(50) NOT NULL,
  "related_entity" VARCHAR(50),
  "related_entity_id" INTEGER,
  "is_read" BOOLEAN DEFAULT false,
  "created_at" timestamp(6) DEFAULT now() NULL,
  "read_at" TIMESTAMP
);

CREATE TABLE "recommendation_logs" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "service_id" INTEGER NOT NULL,
  "tasker_id" INTEGER NOT NULL,
  "recommendation_type" VARCHAR(50) NOT NULL,
  "relevance_score" DECIMAL(5,2),
  "shown_at" timestamp(6) DEFAULT now() NULL,
  "was_clicked" BOOLEAN DEFAULT false,
  "clicked_at" TIMESTAMP,
  "resulted_in_booking" BOOLEAN DEFAULT false,
  "booking_id" INTEGER
);

CREATE TABLE "chatbot_interactions" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "query" TEXT NOT NULL,
  "response" TEXT NOT NULL,
  "created_at" timestamp(6) DEFAULT now() NULL
);

-- Tạo các index bổ sung để tối ưu hiệu suất truy vấn

-- Index cho tìm kiếm tasker theo khu vực địa lý
CREATE INDEX idx_tasker_earth_location ON tasker USING gist(earth_location);

-- Index cho tìm kiếm theo ngày và thời gian đặt lịch
CREATE INDEX "idx_bookings_schedule" ON "bookings" ("scheduled_date", "scheduled_time");

-- Index cho tìm kiếm booking theo trạng thái
CREATE INDEX "idx_bookings_status" ON "bookings" ("status");

-- Index cho khóa ngoại phổ biến
CREATE INDEX "idx_tasker_services_tasker_id" ON "tasker_services" ("tasker_id");
CREATE INDEX "idx_tasker_services_service_id" ON "tasker_services" ("service_id");
CREATE INDEX "idx_bookings_user_id" ON "bookings" ("user_id");
CREATE INDEX "idx_bookings_tasker_id" ON "bookings" ("tasker_id");
CREATE INDEX "idx_bookings_service_id" ON "bookings" ("service_id");
CREATE INDEX "idx_payments_booking_id" ON "payments" ("booking_id");
CREATE INDEX "idx_chat_messages_room_id" ON "chat_messages" ("room_id");
CREATE INDEX "idx_chat_messages_sent_at" ON "chat_messages" ("sent_at");

-- Index cho chức năng tìm kiếm text
CREATE INDEX "idx_services_name_description" ON "services" USING gin(
  to_tsvector('simple', name || ' ' || COALESCE(description, ''))
);

-- Index cho lọc tasker theo dịch vụ và đánh giá
CREATE INDEX "idx_tasker_rating_services" ON "tasker" ("average_rating", "availability_status");

-- Index cho thời gian tạo và cập nhật
CREATE INDEX "idx_bookings_created_at" ON "bookings" ("created_at");
CREATE INDEX "idx_bookings_updated_at" ON "bookings" ("updated_at");

-- Index cho dữ liệu nhiều được truy vấn
CREATE INDEX "idx_notifications_recipient" ON "notifications" ("recipient_type", "recipient_id", "is_read");
CREATE INDEX "idx_tasker_earnings_status" ON "tasker_earnings" ("tasker_id", "status");

-- Thêm các ràng buộc khóa ngoại
ALTER TABLE "user_verifications" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "user_verifications" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "favorite_tasker" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "favorite_tasker" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "favorite_tasker" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");
ALTER TABLE "services" ADD FOREIGN KEY ("category_id") REFERENCES "service_categories" ("id");
ALTER TABLE "tasker_services" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "tasker_services" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");
ALTER TABLE "user_addresses" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "bookings" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "bookings" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "bookings" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");
ALTER TABLE "bookings" ADD FOREIGN KEY ("address_id") REFERENCES "user_addresses" ("id"); 
ALTER TABLE "booking_status_history" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "payment_methods" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "payments" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "payments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "payments" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "payments" ADD FOREIGN KEY ("payment_method_id") REFERENCES "payment_methods" ("id");
ALTER TABLE "tasker_earnings" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "tasker_earnings" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "tasker_payouts" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "reviews" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "chat_rooms" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "chat_rooms" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "chat_rooms" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "chat_messages" ADD FOREIGN KEY ("room_id") REFERENCES "chat_rooms" ("id");
ALTER TABLE "user_preferences" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "user_preferences" ADD FOREIGN KEY ("service_category_id") REFERENCES "service_categories" ("id");
ALTER TABLE "tasker_unavailable_dates" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "system_settings" ADD FOREIGN KEY ("updated_by") REFERENCES "users" ("id");
ALTER TABLE "role_permissions" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "role_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions" ("id");
ALTER TABLE "user_roles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "user_roles" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "user_roles" ADD FOREIGN KEY ("assigned_by") REFERENCES "users" ("id");
ALTER TABLE "tasker_roles" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "tasker_roles" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "tasker_roles" ADD FOREIGN KEY ("assigned_by") REFERENCES "users" ("id");
ALTER TABLE "recommendation_logs" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "recommendation_logs" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");
ALTER TABLE "recommendation_logs" ADD FOREIGN KEY ("tasker_id") REFERENCES "tasker" ("id");
ALTER TABLE "recommendation_logs" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");
ALTER TABLE "chatbot_interactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");