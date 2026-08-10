-- BUCKET 'meal-photos'
-- This bucket will store user uploaded meal photos
insert into storage.buckets (id, name, public)
values ('meal-photos', 'meal-photos', true)
on conflict (id) do nothing;

-- SET UP SECURITY POLICIES (RLS) FOR STORAGE

-- Policy: Allow public read access to all files in 'meal-photos'
-- This allows the admin and the user to view the images
create policy "Public Access"
  on storage.objects for select
  using ( bucket_id = 'meal-photos' );

-- Policy: Allow authenticated users to upload files to their own folder
-- Folder structure: user_uid/filename
create policy "Authenticated users can upload images"
  on storage.objects for insert
  with check (
    bucket_id = 'meal-photos'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Policy: Allow users to update/delete their own files
create policy "Users can update own images"
  on storage.objects for update
  using (
    bucket_id = 'meal-photos'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete own images"
  on storage.objects for delete
  using (
    bucket_id = 'meal-photos'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
