# 📊 Music Store Data Files

This folder contains CSV files and database exports used for the Music Store SQL analysis project.

## 📁 Files Structure

### Database Files:
- **Music_Store_database.sql** - Complete database schema with all tables
- **music_data.sql** - Additional data scripts and sample queries

### CSV Data Files:
- **album.csv** - Album information (album_id, title, artist_id)
- **artist.csv** - Artist details (artist_id, name)
- **customer.csv** - Customer data (customer_id, name, email, country)
- **employee.csv** - Employee records (employee_id, name, title, level)
- **genre.csv** - Music genres (genre_id, name)
- **invoice.csv** - Sales invoices (invoice_id, customer_id, date, total)
- **invoice_line.csv** - Invoice line items (track_id, quantity, unit_price)
- **media_type.csv** - Media formats (media_type_id, name)
- **playlist.csv** - Playlist information
- **playlist_track.csv** - Playlist-track relationships
- **track.csv** - Music tracks (track_id, name, album_id, genre_id, duration)

## 🚀 Usage

1. Import **Music_Store_database.sql** to create the complete database structure
2. Use CSV files for data analysis or additional imports
3. Run SQL queries from the main project for business intelligence insights

## 📈 Data Insights Available

- 🎵 **3,503** total tracks across multiple genres
- 👥 **59** customers from various countries  
- 💰 **412** invoices with detailed transaction data
- 🎸 **347** artists with comprehensive discography
- 🏢 **8** employees across different hierarchy levels
