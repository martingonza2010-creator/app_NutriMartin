-- TRIGGER FOR NEW USERS
-- Automatically create a profile when a new user signs up via Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name, photo_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger execution
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- FIX BIOCHEMICAL EXAMS PERMISSIONS
-- Allow admin to Insert/Update exams if they need to manually input data for a patient
create policy "Admin gestiona examenes"
on public.biochemical_exams for all
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );
