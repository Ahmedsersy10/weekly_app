# Supabase Database Schema for Multi-Device User Data Persistence

This document outlines the database schema required for implementing persistent user identity across devices using Supabase's User ID system.

## Database Tables

### 1. Tasks Table (`tasks`)

```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  is_important BOOLEAN NOT NULL DEFAULT FALSE,
  category_id TEXT NOT NULL DEFAULT 'other',
  priority INTEGER NOT NULL DEFAULT 1 CHECK (priority >= 0 AND priority <= 3),
  due_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  estimated_minutes INTEGER NOT NULL DEFAULT 0,
  tags TEXT[] DEFAULT '{}',
  notes TEXT,
  reminder_time TEXT, -- Format: "HH:MM"
  parent_recurrence_id TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_day_of_week ON tasks(day_of_week);
CREATE INDEX idx_tasks_created_at ON tasks(created_at);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);

-- RLS (Row Level Security) policies
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their own tasks" ON tasks
  FOR ALL USING (auth.uid() = user_id);
```

### 2. Categories Table (`categories`)

```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  icon_code_point INTEGER NOT NULL,
  icon_font_family TEXT,
  color_value INTEGER NOT NULL,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_categories_user_id ON categories(user_id);
CREATE INDEX idx_categories_is_default ON categories(is_default);

-- RLS policies
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can access their own categories and default categories" ON categories
  FOR ALL USING (auth.uid() = user_id OR is_default = true);

-- Insert default categories (these will be available to all users)
INSERT INTO categories (id, user_id, name, name_ar, icon_code_point, color_value, is_default, created_at) VALUES
('work', NULL, 'Work', 'عمل', 57520, 4280391410, true, NOW()),
('study', NULL, 'Study', 'دراسة', 57806, 4281348156, true, NOW()),
('health', NULL, 'Health', 'صحة', 57519, 4293467445, true, NOW()),
('personal', NULL, 'Personal', 'شخصي', 57603, 4286513058, true, NOW()),
('finance', NULL, 'Finance', 'مالي', 58000, 4294951936, true, NOW()),
('home', NULL, 'Home', 'منزل', 57544, 4284513335, true, NOW()),
('shopping', NULL, 'Shopping', 'تسوق', 58732, 4293467443, true, NOW()),
('entertainment', NULL, 'Entertainment', 'ترفيه', 57388, 4278243009, true, NOW()),
('other', NULL, 'Other', 'أخرى', 58306, 4286611584, true, NOW());
```

### 3. User Settings Table (`user_settings`)

```sql
CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  theme_mode INTEGER NOT NULL DEFAULT 0 CHECK (theme_mode >= 0 AND theme_mode <= 2),
  primary_color INTEGER NOT NULL,
  notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  reminder_times JSONB DEFAULT '{}',
  week_start INTEGER NOT NULL DEFAULT 0 CHECK (week_start >= 0 AND week_start <= 6),
  weekend_days INTEGER[] DEFAULT '{6,7}',
  sync_provider INTEGER NOT NULL DEFAULT 2 CHECK (sync_provider >= 0 AND sync_provider <= 2),
  auto_sync BOOLEAN NOT NULL DEFAULT FALSE,
  language INTEGER NOT NULL DEFAULT 0 CHECK (language >= 0 AND language <= 1),
  last_backup TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS policies
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their own settings" ON user_settings
  FOR ALL USING (auth.uid() = user_id);
```

## Triggers for Updated Timestamps

```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to all tables
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_settings_updated_at BEFORE UPDATE ON user_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Data Types Reference

### Task Priority Enum (Flutter)
```dart
enum TaskPriority { low, medium, high, urgent }
// Stored as: 0 = low, 1 = medium, 2 = high, 3 = urgent
```

### Theme Mode Enum (Flutter)
```dart
enum ThemeMode { light, dark, system }
// Stored as: 0 = light, 1 = dark, 2 = system
```

### Language Enum (Flutter)
```dart
enum Language { english, arabic }
// Stored as: 0 = english, 1 = arabic
```

### Week Start Enum (Flutter)
```dart
enum WeekStart { saturday, sunday, monday, tuesday, wednesday, thursday, friday }
// Stored as: 0 = saturday, 1 = sunday, etc.
```

### Sync Provider Enum (Flutter)
```dart
enum SyncProvider { googleDrive, iCloud, none }
// Stored as: 0 = googleDrive, 1 = iCloud, 2 = none
```

## Key Features

### 1. User Data Isolation
- All user data is linked to `auth.users(id)` via foreign keys
- Row Level Security (RLS) ensures users can only access their own data
- Automatic cleanup when user account is deleted (CASCADE)

### 2. Multi-Device Consistency
- Same user ID across all devices when using the same email/provider
- Real-time sync through Supabase's real-time features
- Conflict resolution through timestamps (`updated_at`)

### 3. Default Categories
- System-wide default categories available to all users
- Users can create custom categories linked to their user ID
- Default categories cannot be deleted by users

### 4. Performance Optimization
- Strategic indexes on frequently queried columns
- Efficient queries using user_id filtering
- Optimized for mobile app usage patterns

### 5. Data Migration Support
- Handles migration from local storage to Supabase
- Preserves existing user data during migration
- Intelligent merging of local and remote data

## Usage Examples

### Query User's Tasks
```sql
-- Get all tasks for current user
SELECT * FROM tasks WHERE user_id = auth.uid() ORDER BY created_at DESC;

-- Get tasks for specific day
SELECT * FROM tasks WHERE user_id = auth.uid() AND day_of_week = 1;

-- Get completed tasks
SELECT * FROM tasks WHERE user_id = auth.uid() AND is_completed = true;
```

### Query User's Categories
```sql
-- Get all categories (user's custom + defaults)
SELECT * FROM categories 
WHERE user_id = auth.uid() OR is_default = true 
ORDER BY created_at ASC;
```

### Query User Settings
```sql
-- Get user settings
SELECT * FROM user_settings WHERE user_id = auth.uid();
```

This schema ensures that all user data is properly isolated, synchronized across devices, and maintains referential integrity while providing excellent performance for mobile applications.
