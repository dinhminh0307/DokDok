abstract class DbManager<T> {
  Future<void> insert(T item);
  Future<void> update(T item);
  Future<void> delete(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
}